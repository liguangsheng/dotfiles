# -*- coding: utf-8 -*-

import os
import random
import time

from libqtile.log_utils import logger
from libqtile import qtile
import requests


WALLPAPER_DIR = os.path.expanduser("~/.cache/qtile/wallpapers")
WALLPAPER_CACHE_FILE = os.path.expanduser("~/.cache/qtile/wallpaper")


def format_number(num, precision=1):
    """将数字 num 格式化为精度 precision（0 <= precision <= 15）的字符串"""
    if not isinstance(num, (int, float)):
        raise ValueError("num 参数必须为整数或浮点数")
    if not isinstance(precision, int) or not (0 <= precision <= 15):
        raise ValueError("precision 参数必须为 0 到 15 之间的整数")

    fmt = f"{{:.{precision}f}}"
    return fmt.format(num)


def format_size(num, precision=1, suffix=""):
    for unit in ["", "K", "M", "G", "T", "P", "E", "Z"]:
        if abs(num) < 1024.0:
            break
        num /= 1024.0
    num = format_number(num, precision)
    print(num)
    return f"{num}{unit}{suffix}"


def read_wallpaper_path(*args, **kwargs):
    if os.path.isfile(WALLPAPER_CACHE_FILE):
        with open(WALLPAPER_CACHE_FILE, "r") as f:
            path = f.read()
            if os.path.isfile(path):
                return path

    if os.path.isdir(WALLPAPER_DIR):
        cached_wallpapers = [os.path.join(WALLPAPER_DIR, i) for i in os.listdir(WALLPAPER_DIR) if i.endswith(".jpg")]
        if len(cached_wallpapers) > 0:
            return random.choice(cached_wallpapers)

    return change_wallpaper(qtile, *args, **kwargs)


def change_wallpaper(Q):
    os.makedirs(WALLPAPER_DIR, exist_ok=True)
    resp = requests.get('http://api.btstu.cn/sjbz/?lx=dongman')
    path = os.path.join(WALLPAPER_DIR, str(int(time.time())) + '_' + os.path.basename(resp.url))
    logger.info(f"download wallpaper to {path}")
    with open(path, 'wb') as f:
        f.write(resp.content)

    with open(WALLPAPER_CACHE_FILE, "w") as f:
        f.write(path)
    Q.current_screen.cmd_set_wallpaper(path)
    logger.info(f"switch_wallpaper invoked, {path}")


def color_variant(hex_color, brightness_offset=1):
    """ takes a color like #87c95f and produces a lighter or darker variant """
    if len(hex_color) != 7:
        raise Exception("Passed %s into color_variant(), needs to be in #87c95f format." % hex_color)
    rgb_hex = [hex_color[x:x+2] for x in [1, 3, 5]]
    new_rgb_int = [int(hex_value, 16) + brightness_offset for hex_value in rgb_hex]
    new_rgb_int = [min([255, max([0, i])]) for i in new_rgb_int] # make sure new values are between 0 and 255
    # hex() produces "0x88", we want just "88"
    return "#" + "".join([hex(i)[2:] for i in new_rgb_int])


