#!/bin/bash

# 获取要卸载的软件包列表
package_list=$(dpkg -l | grep "$1" | awk '{print $2}')

# 循环遍历软件包列表并执行卸载
for package in $package_list; do
    sudo dpkg --purge $package
done

echo "所有相关软件包已卸载。"

