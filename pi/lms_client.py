from __future__ import annotations

import asyncio
import json
import logging
import urllib.request

log = logging.getLogger(__name__)


class LMSClient:
    """Async control of a single named player on the Lyrion Music Server.

    Talks to the LMS JSON-RPC endpoint (/jsonrpc.js). The player id (MAC) is
    resolved from the player name and cached; the cache is dropped on any
    request failure so a player reboot or address change can't permanently
    break control. HTTP runs in a worker thread (urllib) to stay off the loop.
    """

    def __init__(self, host: str, port: int, player_name: str,
                 volume_step: int = 5, timeout: float = 5.0):
        self._url = f"http://{host}:{port}/jsonrpc.js"
        self._player_name = player_name
        self._volume_step = volume_step
        self._timeout = timeout
        self._player_id: str | None = None

    def _post(self, player_id: str, command: list) -> dict:
        body = json.dumps({
            "id": 1,
            "method": "slim.request",
            "params": [player_id, command],
        }).encode()
        req = urllib.request.Request(
            self._url, data=body, headers={"Content-Type": "application/json"},
        )
        with urllib.request.urlopen(req, timeout=self._timeout) as resp:
            return json.loads(resp.read())["result"]

    async def _resolve(self) -> str:
        if self._player_id:
            return self._player_id
        result = await asyncio.to_thread(self._post, "-", ["players", "0", 100])
        for p in result.get("players_loop", []):
            if p.get("name") == self._player_name:
                self._player_id = p["playerid"]
                log.info("Resolved LMS player %r -> %s",
                         self._player_name, self._player_id)
                return self._player_id
        raise LookupError(f"LMS player {self._player_name!r} not found")

    async def _request(self, command: list) -> dict:
        pid = await self._resolve()
        try:
            return await asyncio.to_thread(self._post, pid, command)
        except Exception:
            self._player_id = None  # force re-resolve on next call
            raise

    # ------------------------------------------------------------------ #
    # Media actions — each swallows/logs errors so a flaky network or a   #
    # sleeping player never kills the button-poll loop.                   #
    # ------------------------------------------------------------------ #

    async def play_pause(self):
        """Toggle playback: stopped/paused -> play, playing -> pause."""
        try:
            status = await self._request(["status", "-", 1])
            cmd = ["pause", "1"] if status.get("mode") == "play" else ["play"]
            await self._request(cmd)
        except Exception as exc:
            log.warning("LMS play_pause failed: %s", exc)

    async def power_toggle(self):
        """Toggle the player on/off (the old `media_player.toggle` behavior)."""
        try:
            await self._request(["power"])
        except Exception as exc:
            log.warning("LMS power_toggle failed: %s", exc)

    async def volume_up(self):
        await self._action("volume_up",
                           ["mixer", "volume", f"+{self._volume_step}"])

    async def volume_down(self):
        await self._action("volume_down",
                           ["mixer", "volume", f"-{self._volume_step}"])

    async def next_track(self):
        await self._action("next_track", ["playlist", "index", "+1"])

    async def prev_track(self):
        await self._action("prev_track", ["playlist", "index", "-1"])

    async def _action(self, name: str, command: list):
        try:
            await self._request(command)
        except Exception as exc:
            log.warning("LMS %s failed: %s", name, exc)
