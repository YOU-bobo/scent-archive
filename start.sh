#!/bin/bash
# 跨平台启动脚本 - 自动检测系统并选择对应启动方式
# Windows 用 Git Bash / WSL 运行，或直接用 start-windows.bat
# macOS / Linux 直接运行 ./start.sh

cd "$(dirname "$0")"

OS=$(uname -s)
case "$OS" in
    MINGW*|MSYS*|CYGWIN*)
        # Windows Git Bash
        exec cmd //c start-windows.bat
        ;;
    Darwin)
        # macOS
        exec ./start-mac.command
        ;;
    Linux)
        # Linux
        exec ./start-linux.sh
        ;;
    *)
        echo "未知系统: $OS"
        echo "请手动运行对应平台的脚本"
        read -p "按回车键退出..."
        exit 1
        ;;
esac
