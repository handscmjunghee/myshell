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
  local governors
  for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    governors+=("$(basename $(dirname $cpu)): $(cat $cpu)")
  done
  dialog --title "当前CPU调度策略" --msgbox "$(IFS=$'\n'; echo "${governors[*]}")" 10 40
}

# 主菜单
menu() {
  dialog --clear --title "CPU调度策略设置" --menu "请选择操作:" 10 40 4 \
    1 "设置调度策略" \
    2 "查询当前调度策略" \
    0 "退出" \
    2>&1 >/dev/tty
}

# 处理用户输入
process_input() {
  local choice="$1"
  case $choice in
    1)
      local available_governors=($(get_available_governors))
      local options=()
      for governor in "${available_governors[@]}"; do
        options+=("$governor" "")
      done
      local selected_governor
      selected_governor=$(dialog --clear --title "选择调度策略" --menu "可用的调度策略:" 10 40 6 "${options[@]}" 2>&1 >/dev/tty)
      if [ -n "$selected_governor" ]; then
        set_scaling_governor "$selected_governor"
        dialog --clear --title "设置成功" --msgbox "已设置为 $selected_governor 调度策略" 10 40
      fi
      ;;
    2)
      show_scaling_governor
      ;;
    0)
      exit 0
      ;;
    *)
      dialog --clear --title "无效的选项" --msgbox "请输入有效的选项" 10 40
      ;;
  esac
}

# 主循环
while true; do
  choice=$(menu)
  process_input "$choice"
done
