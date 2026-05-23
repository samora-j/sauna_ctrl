import asyncio
import json
import logging

import websockets
from websockets.server import WebSocketServerProtocol

log = logging.getLogger(__name__)

_PORT = 8765


async def ws_server_task(
    outbound: asyncio.Queue,
    state,
    on_sensors,
    on_power_btn,
    on_connect,
    on_disconnect,
):
    async def handler(websocket: WebSocketServerProtocol):
        addr = websocket.remote_address
        log.info("LabVIEW RT connected from %s", addr)
        state.ws_connected = True
        await on_connect()

        # Send initial states so LabVIEW RT is in sync immediately
        for msg in [
            {"type": "power_indicator",     "state": state.power_on},
            {"type": "aroma_button_light",  "state": False},
            {"type": "spray_button_light",  "state": False},
        ]:
            await websocket.send(json.dumps(msg))

        async def drain():
            while True:
                msg = await outbound.get()
                await websocket.send(json.dumps(msg))
                outbound.task_done()

        drain_task = asyncio.create_task(drain())
        try:
            async for raw in websocket:
                try:
                    msg = json.loads(raw)
                    t = msg.get("type")
                    if t == "sensors":
                        await on_sensors(msg)
                    elif t == "power_button":
                        await on_power_btn()
                    else:
                        log.debug("Unknown message type: %s", t)
                except json.JSONDecodeError:
                    log.warning("Received non-JSON frame: %r", raw)
                except Exception:
                    log.exception("Error handling inbound message")
        finally:
            drain_task.cancel()
            state.ws_connected = False
            await on_disconnect()
            log.info("LabVIEW RT disconnected from %s", addr)

    async with websockets.serve(handler, "", _PORT):
        log.info("WebSocket server listening on port %d", _PORT)
        await asyncio.Future()  # run forever
