import asyncio
import websockets

async def hello():
    async with websockets.connect("ws://127.0.0.1:3333") as websocket:
        await websocket.send("Hello from Python!")
        msg = await websocket.recv()
        print(msg)


if __name__ == "__main__":
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    loop.run_until_complete(hello())


