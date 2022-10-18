#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# wallpaper manager script

from pathlib import Path, PurePath
import json
import os
import shutil
import argparse
import urllib.request
import random

MAX_KEEP = 100
XDG_DATA_HOME = os.environ.get("XDG_DATA_HOME", "~/.local/share")
BASE_PATH = Path(XDG_DATA_HOME) / "wpm"
DOWNLOADS_PATH = BASE_PATH / "downloads"
COLLECTIONS_PATH = BASE_PATH / "collections"
os.makedirs(DOWNLOADS_PATH, exist_ok=True)
os.makedirs(COLLECTIONS_PATH, exist_ok=True)


def keep_latest_files(path: Path, keep_count):
    # 获取所有文件的列表
    files = list(path.iterdir())

    # 对文件列表按照修改时间排序
    files.sort(key=lambda f: f.stat().st_mtime)

    # 删除最早的文件
    for file in files[:-keep_count]:
        file.unlink(missing_ok=True)


def _pull_once():
    response = urllib.request.urlopen(
        "http://api.btstu.cn/sjbz/api.php?lx=dongman&format=json")
    json_data = json.loads(response.read().decode("utf-8"))
    wallpaper_url = json_data["imgurl"]
    wallpaper_path = DOWNLOADS_PATH / PurePath(wallpaper_url).name
    response = urllib.request.urlopen(wallpaper_url)
    wallpaper_path.write_bytes(response.read())
    return wallpaper_path


def pull_wallpaper(n=1):
    paths = [_pull_once() for _ in range(n)]
    keep_latest_files(DOWNLOADS_PATH, MAX_KEEP)
    return paths


def apply_wallpaper(path):
    os.system(f"feh --bg-scale {path}")


def get_current_wallpaper_path():
    fehbg_text = Path("~/.fehbg").expanduser().read_text()
    wallpaper_path = fehbg_text.split("'")[1]
    return wallpaper_path


def command_collect(*args, **kwargs):
    target_path = COLLECTIONS_PATH
    sub_path = kwargs['sub_path']
    if sub_path is not None:
        target_path = target_path / sub_path
    wallpaper_path = get_current_wallpaper_path()
    shutil.copy(wallpaper_path, target_path)


def command_current(**kwargs):
    print(get_current_wallpaper_path())


def command_pull(**kwargs):
    print(str(pull_wallpaper()[0]))


def command_apply_next(**kwargs):
    path = str(pull_wallpaper()[-1])
    apply_wallpaper(path)


def command_apply_collections(**kwargs):
    target_path = COLLECTIONS_PATH
    sub_path = kwargs['sub_path']
    if sub_path is not None:
        target_path = target_path / sub_path
    image_extensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp']
    files = [
        f for f in target_path.iterdir()
        if f.is_file() and f.suffix in image_extensions
    ]
    wallpaper = random.choice(files)
    apply_wallpaper(str(wallpaper))


def main():
    parser = argparse.ArgumentParser(description='Process some commands')

    # Add a top-level parser for the "command" argument
    subparsers = parser.add_subparsers(title='Commands', dest='command')

    # Create a parser for the "collect" command
    parser_collect = subparsers.add_parser('collect', help='Collect')
    parser_collect.add_argument('sub_path',
                                type=str,
                                nargs='?',
                                help='The sub path from COLLECTIONS_PATH')
    parser_collect.set_defaults(func=command_collect)

    # Create a parser for the "current" command
    parser_current = subparsers.add_parser('current',
                                           help='Show current wallpaper path')
    parser_current.set_defaults(func=command_current)

    # Create a parser for the "pull" command
    parser_pull = subparsers.add_parser('pull', help='Pull wallpapers')
    parser_pull.set_defaults(func=command_pull)

    # Create a parser for the "apply_next" command
    parser_apply_next = subparsers.add_parser(
        'apply_next', help='Pull next wallpaper and apply')
    parser_apply_next.set_defaults(func=command_apply_next)

    # Create a parser for the "apply_collection" command
    parser_apply_collections = subparsers.add_parser(
        'apply_collections',
        help='Choose wallpaper from collections, and apply')
    parser_apply_collections.set_defaults(func=command_apply_collections)
    parser_apply_collections.add_argument(
        'sub_path',
        type=str,
        nargs='?',
        help='The sub path from COLLECTIONS_PATH')

    # Parse the command-line arguments
    args = parser.parse_args()
    if hasattr(args, "func"):
        args.func(**vars(args))
    else:
        command_apply_next()


if __name__ == "__main__":
    main()
