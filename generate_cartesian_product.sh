#!/bin/bash

# 创建一个空的 CSV 文件
echo "Character" > characters.csv

# 循环遍历 0~9 和 A~Z
for i in {0..9} {A..Z}; do
    for j in {0..9} {A..Z}; do
        # 将字符拼接成两位字符并写入 CSV 文件
        echo "$i$j" >> characters.csv
    done
done
