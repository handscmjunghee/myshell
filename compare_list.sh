#!/bin/bash

# 检查参数数量
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <file-path-1> <file-path-2>"
  exit 1
fi

# 读取文件内容
list1=$(cat "$1")
list2=$(cat "$2")

# 将逗号分隔的字符串转换为数组
IFS=',' read -r -a array1 <<< "$list1"
IFS=',' read -r -a array2 <<< "$list2"

# 将数组2的元素转为一行
array2_line=$(printf "%s\n" "${array2[@]}")

# 遍历数组1中的元素，检查它们是否在数组2中
for num1 in "${array1[@]}"; do
  if ! echo "$array2_line" | grep -q -w "$num1"; then
    echo "$num1"
  fi
done
