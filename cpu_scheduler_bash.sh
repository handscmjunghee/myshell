#!/bin/bash

# 获取所有可用的调度策略
get_available_governors() {
  cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
}

# 设置CPU调度策略
set_scaling_governor() {
  local governor="$1"
  for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo "$governor" | sudo tee "$cpu" > /dev/null
  done
}

# 获取当前CPU调度策略
get_current_governor() {
  cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
}

# 显示当前CPU调度策略
show_scaling_governor() {
  for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo "$cpu: $(cat $cpu)"
  done
}

# 主菜单
menu() {
  echo "请选择操作:"
  echo "1. 设置调度策略"
  echo "2. 查询当前调度策略"
  echo "0. 退出"
  echo -n "输入选项: "
}

# 处理用户输入
process_input() {
  local choice="$1"
  case $choice in
    1)
      echo "可用的调度策略:"
      local available_governors=($(get_available_governors))
      for ((i=0; i<${#available_governors[@]}; i++)); do
        echo "$i. ${available_governors[$i]}"
      done
      echo -n "选择调度策略的编号: "
      read governor_choice
      if [[ $governor_choice =~ ^[0-9]+$ ]] && [ $governor_choice -ge 0 ] && [ $governor_choice -lt ${#available_governors[@]} ]; then
        local governor="${available_governors[$governor_choice]}"
        set_scaling_governor "$governor"
        echo "已设置为 $governor 调度策略"
      else
        echo "无效的选项"
      fi
      ;;
    2)
      show_scaling_governor
      ;;
    0)
      exit 0
      ;;
    *)
      echo "无效的选项"
      ;;
  esac
}

# 主循环
while true; do
  menu
  read choice
  process_input "$choice"
  echo
done
