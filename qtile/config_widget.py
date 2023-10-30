# -*- coding: utf-8 -*-

from datetime import datetime
import os

from libqtile import widget
from libqtile.widget import base
import psutil

import config_utils


class Kernel(base.ThreadPoolText):
    defaults = [
            ("format", "{uname}", "Formatting for field names."),
            ("update_interval", 3600.0, "Update interval for the Memory"),
            ]

    def __init__(self, **config):
        super().__init__("", **config)
        self.add_defaults(Kernel.defaults)

    def poll(self):
        uname = os.uname()
        return self.format.format(release=uname.release)


class Memory(base.ThreadPoolText):
    defaults = [
            ("format", "{MemPercent: .0f}%", "Formatting for field names."),
            ("update_interval", 1.0, "Update interval for the Memory"),
            ]

    def __init__(self, **config):
        super().__init__("", **config)
        self.add_defaults(Memory.defaults)

    def poll(self):
        mem = psutil.virtual_memory()
        val = {}
        val["MemPercent"] = mem.percent
        val["MemUsedHuman"] = config_utils.format_size(mem.used)
        return self.format.format(**val)


class Uptime(base.ThreadPoolText):
    defaults = [
            ("format", "{days}d {hours}h {minutes}m {seconds}s", "Formatting for field names."),
            ("update_interval", 1.0, "Update interval for the Memory"),
            ]

    def __init__(self, **config):
        super().__init__("", **config)
        self.add_defaults(Uptime.defaults)

    def poll(self):
        parts = []
        sec = int(datetime.now().timestamp() - psutil.boot_time())
        days, rem = divmod(sec, 86400)
        parts.append(f'{days}')
        hours, rem = divmod(rem, 3600)
        parts.append(f'{hours:02}')
        minutes, seconds= divmod(rem, 60)
        parts.append(f'{minutes:02}')
        parts.append(f'{seconds:02}')
        return self.prefix + ' ' + ':'.join(parts)


class QtileMemory(base.ThreadPoolText):
    defaults = [
            ("format", "QM {qm}", "Formatting for field names."),
            ("update_interval", 5.0, "Update interval for the Memory"),
            ]

    process = psutil.Process(os.getpid())


    def __init__(self, **config):
        super().__init__("", **config)
        self.add_defaults(QtileMemory.defaults)


    def poll(self):
        qm = config_utils.format_size(self.process.memory_info().rss, precision=0)
        return self.format.format(qm=qm)


class DiskUsage(widget.DF):
    def poll(self):
        statvfs = os.statvfs(self.partition)

        size = statvfs.f_frsize * statvfs.f_blocks
        free = statvfs.f_frsize * statvfs.f_bfree
        used = size - free
        self.user_free = statvfs.f_frsize * statvfs.f_bavail

        if self.visible_on_warn and self.user_free >= self.warn_space:
            text = ""
        else:
            text = self.format.format(
                    p=self.partition,
                    s=size,
                    f=free,
                    u=used,
                    uf=self.user_free,
                    m=self.measure,
                    r=used / size * 100,
                    uh=config_utils.format_size(used),
                    )

        return text
