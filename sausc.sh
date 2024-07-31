#!/bin/bash
 
# 使用 nohup 启动一个进程，并忽略 SIGHUP 信号
nohup bash -c '
# 设置无终止挂起的进程
while true; do
    sleep 1
done' & disown
 
# 存储子进程的进程ID
sub_process_pid=$!
 
# 初始化一个数组来保存-d参数的值
domains=()
param_p=""
custom_script=""
exec_date_time=""
 
# 获取所有参数
while getopts "d:p:e:t:" opt; do
  case $opt in
    d) domains+=("$OPTARG") ;;
    p) param_p="$OPTARG" ;;
    e) custom_script="$OPTARG" ;;
    t) exec_date_time="$OPTARG" ;;
  esac
done
 
if [ ${#domains[@]} -eq 0 ]; then
  echo "错误：必须为 -d 选项传入至少一个值" >&2
  exit 1
fi
 
if [ -z "$param_p" ]; then
  echo "脚本执行错误：必须为 -p 选项传入值" >&2
  exit 1
fi
 
if [ -z "$custom_script" ]; then
  echo "脚本执行错误：必须为 -e 选项传入值" >&2
  exit 1
fi
 
# 打印完整参数
echo "完整参数为: $@"
 
# 移动ssl证书文件
move_ssl_file() {
  for domain in "${domains[@]}"; do
    if [ ! -d "$param_p/$domain/" ]; then
        mkdir -p "$param_p/$domain/"
        echo "目录已创建: $param_p/$domain/"
    fi
 
    echo "正在移动ssl证书..."
    mv "./$domain.key" "$param_p/$domain/"
    mv "./$domain.pem" "$param_p/$domain/"
    echo "完成移动ssl证书..."
  done
}
 
# 定义执行自定义脚本的函数
execute_custom_script() {
  if [ -n "$custom_script" ]; then
    # 为了避免执行脚本有问题时，ssl文件已经被移动，所以在执行自定义脚本函数内部移动ssl文件
    move_ssl_file
    echo "执行自定义脚本: $custom_script"
    eval "/bin/bash -c \"$custom_script\""
 
    # 脚本执行完毕后清理无终止挂起进程
    kill "$sub_process_pid"
  fi
}
 
if [ -n "$exec_date_time" ]; then
  echo "有指定执行时间，时间是：" "$exec_date_time"
  sleep $exec_date_time
  execute_custom_script
else
  execute_custom_script
fi