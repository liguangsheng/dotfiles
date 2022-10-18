from datetime import datetime
import asyncio
import os
import shutil

import requests
import psutil

BOOT_TIME = psutil.boot_time()
WEEKDAYS = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"]


class Block:

    def __init__(self, func, **kwargs):
        if not asyncio.iscoroutinefunction(func):
            raise ValueError(f"{func} is not a coroutine function")
        self.func = func
        self.content = None
        self.interval = kwargs.get('interval', 1)

    async def update(self):
        while True:
            self.content = await self.func()
            await asyncio.sleep(self.interval)


class DWMBlocks:

    def __init__(self, blocks: list):
        self.blocks = blocks

    async def run(self):
        self.tasks = [
            asyncio.create_task(block.update()) for block in self.blocks
        ]
        asyncio.create_task(self.render())
        await asyncio.gather(*self.tasks)

    async def render(self):
        while True:
            contents = [block.content for block in self.blocks]
            content = " | ".join(contents) + " |"
            # print(content)
            os.system(f'xsetroot -name "{content}"')
            await asyncio.sleep(1)


async def btcprice():
    URL = "https://api.coindesk.com/v1/bpi/currentprice.json"
    r = requests.get(URL)
    data = r.json()
    price = data['bpi']['USD']['rate_float']
    return f' {price:.0f}'


async def kernel():
    return f' {os.uname().release}'


async def uptime():
    sec = int(datetime.now().timestamp() - BOOT_TIME)
    day, rem = divmod(sec, 86400)
    hour, rem = divmod(rem, 3600)
    min, sec = divmod(rem, 60)

    s_day = f'{day}d,' if day > 0 else ''
    s_hour = f'{hour}h,' if hour > 0 else ''
    s_min = f'{min}m,' if min > 0 else ''
    s_sec = f'{sec}s'

    return f' {s_day}{s_hour}{s_min}{s_sec}'


async def cpu():
    return f"﬙ {psutil.cpu_percent():.1f}%"


async def disk():
    d = shutil.disk_usage('/')
    pct = round(d.used / d.total * 100)
    used_gb = round(d.used / 1024 / 1024 / 1024)
    return f' {used_gb}G({pct}%)'


async def memory():
    vm = psutil.virtual_memory()
    percent = vm.used / vm.total * 100
    used_mb = vm.used / 1024 / 1024
    return f' {percent:.1f}%({used_mb:.0f}M)'


async def datetime_block():
    now = datetime.now()
    weekday = WEEKDAYS[now.weekday()]
    return f' {now.strftime("%Y-%m-%d %H:%M:%S")} {weekday}'


async def main():
    blocks = [
        # Block(btcprice, interval=60),
        Block(kernel, interval=600),
        Block(uptime),
        Block(cpu),
        Block(memory),
        Block(disk, interval=10),
        Block(datetime_block),
    ]
    dwmblocks = DWMBlocks(blocks)

    await asyncio.wait([
        asyncio.create_task(dwmblocks.run()),
    ])


if __name__ == '__main__':
    asyncio.run(main())
