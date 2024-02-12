#!/bin/bash

# 检查参数数量
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <URL> <Interval(minutes)>"
    exit 1
fi

# 解析参数
url="$1"
interval="$2"

# 初始化计数器
counter=0

# 循环定时请求
while true; do
    # 请求网址
    curl -s "$url" > /dev/null

    # 增加计数器
    counter=$((counter + 1))

    # 打印已请求次数
    echo "Requested $url $counter times."

    # 等待指定的时间间隔（分钟）
    sleep "$((interval * 60))"
done
