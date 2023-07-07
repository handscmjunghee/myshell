#!/bin/bash

APP_IMAGE_PATH=$1
ICON_PATH=$2

# 提取.AppImage文件的文件名（不包含扩展名）
APP_NAME=$(basename "$APP_IMAGE_PATH" | cut -d. -f1)

# 将.AppImage文件复制到本地应用目录
mkdir -p "$HOME/.local/bin"
cp "$APP_IMAGE_PATH" "$HOME/.local/bin/$APP_NAME"

# 设置可执行权限
chmod +x "$HOME/.local/bin/$APP_NAME"

# 创建.desktop文件
DESKTOP_FILE="$HOME/.local/share/applications/$APP_NAME.desktop"
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=$APP_NAME
Exec=$HOME/.local/bin/$APP_NAME
Icon=$ICON_PATH
Terminal=false" > "$DESKTOP_FILE"

# 将.desktop文件复制到桌面
cp "$DESKTOP_FILE" "$HOME/Desktop/$APP_NAME.desktop"

# 更新.desktop文件权限
chmod +x "$HOME/Desktop/$APP_NAME.desktop"
