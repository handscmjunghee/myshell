#!/bin/bash

# 检查参数是否为空
if [ $# -eq 0 ]; then
    echo "Usage: $0 <DNS1> [<DNS2> ...]"
    exit 1
fi

# 清空旧的 DNS 设置
sudo networksetup -setdnsservers Wi-Fi empty

# 添加新的 DNS 设置
for dns in "$@"; do
    sudo networksetup -setdnsservers Wi-Fi $dns
done

echo "DNS 设置完成。"
