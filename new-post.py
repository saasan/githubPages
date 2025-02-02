from pathlib import Path
import re
import subprocess
import datetime
import os


# レイアウト
LAYOUT = "page"
# 新しいポストを作成するパス
OUTPUT_PATH = ["_source", "_posts"]
#  拡張子
EXTENSION = ".md"
#  新しいPostを開くエディターのパス
EDITOR = "code"
#  ファイル名に使用できない文字 '!"#$%&()*,/:;?@[]^`{|}\+<=>
INVALID_FILENAME_CHAR = re.compile(r"[ '!\"#$%&\(\)\*,/:;?@\[\]^`{|}\\+<=>]+")


# ------------------------------------------------------------------------------
# YAML front matterを作成
# ------------------------------------------------------------------------------
def create_yaml_front_matter(date: datetime.datetime, title: str) -> str:
    date_time_string = date.strftime("%Y-%m-%d %H:%M:%S")
    return f"""---
layout: {LAYOUT}
title: {title}
date: {date_time_string} +0900
category: blog
tags: []
description:
---

"""


# -----------------------------------------------------------------------------
# ファイル名を作成
# -----------------------------------------------------------------------------
def create_file_name(date: datetime.datetime, title: str) -> str:
    date_string = date.strftime("%Y-%m-%d")
    sanitized_title = INVALID_FILENAME_CHAR.sub('-', title).lower()
    return f"{date_string}-{sanitized_title}{EXTENSION}"


# -----------------------------------------------------------------------------
# 新しいPostを作成
# -----------------------------------------------------------------------------
def create_new_post(title: str) -> Path:
    today = datetime.datetime.now()
    front_matter = create_yaml_front_matter(today, title)
    output_path = os.path.join(Path(__file__).parent, *OUTPUT_PATH)
    os.makedirs(output_path, exist_ok=True)

    file_name = create_file_name(today, title)
    file_path = os.path.join(output_path, file_name)

    with open(file_path, "w", encoding="utf-8") as f:
        f.write(front_matter)

    return file_path


# -----------------------------------------------------------------------------
# メイン
# -----------------------------------------------------------------------------
def main():
    title = input("タイトルを入力して下さい: ")
    file_path = create_new_post(title)
    subprocess.run([EDITOR, file_path])


if __name__ == "__main__":
    main()
