import asyncio
import json
import logging

import websockets

log = logging.getLogger(__name__)

_URI = "ws://10.20.6.2:6123"
_RECONNECT_DELAY = 5.0


async def ws_client_task(
    outbound: asyncio.Queue,
    state,
    on_sensors,
    on_connect,
    on_disconnect,
):
    while True:
        try:
            async with websockets.connect(_URI) as websocket:
                log.info("Connected to sbRIO at %s", _URI)
                state.ws_connected = True
                await on_connect()

                async def drain():
                    while True:
                        msg = await outbound.get()
                        await websocket.send(json.dumps(msg))
                        outbound.task_done()

                drain_task = asyncio.create_task(drain())
                try:
                    async for raw in websocket:
                        try:
                            await on_sensors(json.loads(raw))
                        except json.JSONDecodeError:
                            log.warning("Received non-JSON frame: %r", raw)
                        except Exception:
                            log.exception("Error handling inbound message")
                finally:
                    drain_task.cancel()
                    state.ws_connected = False
                    await on_disconnect()
                    log.info("Disconnected from sbRIO")
        except (OSError, websockets.WebSocketException) as exc:
            log.warning("WS error: %s — reconnecting in %.0f s", exc, _RECONNECT_DELAY)
            await asyncio.sleep(_RECONNECT_DELAY)
