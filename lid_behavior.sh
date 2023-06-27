#!/bin/bash

# 检查是否安装了dialog
if ! command -v dialog >/dev/null 2>&1; then
    echo "请先安装dialog库：sudo apt install dialog"
    exit 1
fi

# 定义文件路径
config_file="/etc/systemd/logind.conf"

# 定义函数：设置关闭盖子后的行为
set_lid_behavior() {
    choice=$1
    case $choice in
        1) sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' "$config_file" ;;
        2) sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=lock/' "$config_file" ;;
        3) sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=suspend/' "$config_file" ;;
        4) sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=poweroff/' "$config_file" ;;
    esac
    sudo systemctl restart systemd-logind
}

# 定义函数：查询当前设置的关闭盖子后的行为
get_lid_behavior() {
    behavior=$(grep -oP '^HandleLidSwitch=\K\w+' "$config_file")
    case $behavior in
        ignore) behavior="关闭盖子后不待机也不断网" ;;
        lock) behavior="关闭盖子后待机并断网" ;;
        suspend) behavior="关闭盖子后待机并断网，同时断开网络连接" ;;
        poweroff) behavior="关闭盖子后关机" ;;
        *) behavior="未知设置" ;;
    esac
    dialog --clear --backtitle "笔记本电脑电源设置" --title "当前设置" --msgbox "$behavior" 8 40
}

# 显示主菜单
while true; do
    choice=$(dialog --clear --backtitle "笔记本电脑电源设置" --title "主菜单" \
        --menu "请选择一项操作：" 12 50 5 \
        1 "设置关闭盖子后不待机也不断网" \
        2 "设置关闭盖子后待机并断网" \
        3 "设置关闭盖子后待机并断网，同时断开网络连接" \
        4 "设置关闭盖子后关机" \
        5 "查询当前设置" \
        6 "退出" 3>&1 1>&2 2>&3)

    # 检查是否取消选择
    if [ $? -ne 0 ]; then
        exit 0
    fi

    case $choice in
        1|2|3|4) set_lid_behavior "$choice" ;;
        5) get_lid_behavior ;;
        6) exit 0 ;;
        *) echo "无效选择，请重新选择" ;;
    esac
done
