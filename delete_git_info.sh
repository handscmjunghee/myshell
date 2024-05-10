#!/bin/bash

# 函数定义：递归删除所有的.git文件夹
function delete_git_folders {
    # 查找当前目录下的所有.git文件夹
    git_folders=$(find "$1" -type d -name ".git")
    
    # 循环遍历每个.git文件夹并删除
    for folder in $git_folders; do
        echo "Deleting $folder"
        rm -rf "$folder"
    done
}

# 判断输入参数是否为空
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# 检查输入的目录是否存在
if [ ! -d "$1" ]; then
    echo "Directory '$1' not found."
    exit 1
fi

# 执行删除.git文件夹的函数
delete_git_folders "$1"

echo "All .git folders deleted recursively from $1"

