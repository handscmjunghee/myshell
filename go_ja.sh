#!/bin/bash

# 定义假名和罗马音的映射
kana_romaji=(
    "あ ア a" "い イ i" "う ウ u" "え エ e" "お オ o"
    "か カ ka" "き キ ki" "く ク ku" "け ケ ke" "こ コ ko"
    "さ サ sa" "し シ shi" "す ス su" "せ セ se" "そ ソ so"
    "た タ ta" "ち チ chi" "つ ツ tsu" "て テ te" "と ト to"
    "な ナ na" "に ニ ni" "ぬ ヌ nu" "ね ネ ne" "の ノ no"
    "は ハ ha" "ひ ヒ hi" "ふ フ fu" "へ ヘ he" "ほ ホ ho"
    "ま マ ma" "み ミ mi" "む ム mu" "め メ me" "も モ mo"
    "や ヤ ya" "ゆ ユ yu" "よ ヨ yo"
    "ら ラ ra" "り リ ri" "る ル ru" "れ レ re" "ろ ロ ro"
    "わ ワ wa" "を ヲ wo" "ん ン n"
)

# 游戏开始
echo "欢迎来到假名罗马音游戏！"

# 获取倒计时时间
if [ $# -eq 0 ]; then
    countdown=3
else
    countdown=$1
fi

while true; do
    # 随机选择一个假名
    random_index=$((RANDOM % ${#kana_romaji[@]}))
    selected=${kana_romaji[$random_index]}

    # 提取假名和平假名
    kana=$(echo $selected | awk '{print $1 " " $2}')
    romaji=$(echo $selected | awk '{print $3}')

    # 提示玩家输入
    echo "假名: $kana"
    echo "请立即输入对应的罗马音:"

    # 启动倒计时
    input=""
    (
        for ((i=$countdown; i>0; i--)); do
            echo -ne "\r倒计时: $i " >&2
            sleep 1
        done
    ) &
    timer_pid=$!

    # 读取用户输入
    read -t $countdown -p "输入: " input
    kill $timer_pid 2>/dev/null
    echo -ne "\r               \r" >&2  # 清除倒计时显示

    # 检查输入是否正确
    if [[ "$input" == "$romaji" ]]; then
        echo "正确！继续挑战！"
    else
        echo "错误！正确答案是: $romaji"
        echo "Game Over!"
        break
    fi

done
