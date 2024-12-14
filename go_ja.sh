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

while true; do
    # 随机选择一个假名
    random_index=$((RANDOM % ${#kana_romaji[@]}))
    selected=${kana_romaji[$random_index]}

    # 提取假名和平假名
    kana=$(echo $selected | awk '{print $1 " " $2}')
    romaji=$(echo $selected | awk '{print $3}')

    # 提示玩家输入
    echo "假名: $kana"
    echo "请在 3 秒内输入对应的罗马音:"

    # 倒计时
    for i in {10..1}; do
        echo -n "$i "
        sleep 1
    done
    echo

    # 读取玩家输入
    read -t 1 -p "输入: " input

    # 检查输入是否正确
    if [[ "$input" == "$romaji" ]]; then
        echo "正确！继续挑战！"
    else
        echo "错误！正确答案是: $romaji"
        echo "Game Over!"
        break
    fi

done
