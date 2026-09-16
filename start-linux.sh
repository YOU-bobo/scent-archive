#!/bin/bash
# 气味档案室 · AI香氛课程工作台 - Linux 一键启动脚本

# 切换到脚本所在目录
cd "$(dirname "$0")"

# 检查 index.html
if [ ! -f "index.html" ]; then
    echo "[错误] 未找到 index.html 文件！"
    echo "请确保此脚本与网站文件在同一文件夹。"
    read -p "按回车键退出..."
    exit 1
fi

# 检查 Python
if command -v python3 &> /dev/null; then
    PYCMD="python3"
    PYVER=$($PYCMD --version 2>&1)
elif command -v python &> /dev/null; then
    PYCMD="python"
    PYVER=$($PYCMD --version 2>&1)
else
    echo "[错误] 未检测到 Python"
    echo "请安装 Python3:"
    echo "  sudo apt install python3      # Debian/Ubuntu"
    echo "  sudo yum install python3      # CentOS/RHEL"
    read -p "按回车键退出..."
    exit 1
fi

# 获取本机 IP
LOCAL_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
if [ -z "$LOCAL_IP" ]; then
    LOCAL_IP="127.0.0.1"
    LAN_MSG="⚠ 未获取到局域网 IP，仅本机可访问"
else
    LAN_MSG="📱 局域网访问 (手机同 WiFi): http://$LOCAL_IP:8080/"
fi

PORT=8080

clear
echo "═══════════════════════════════════════════════"
echo "  🌸 气味档案室 · AI香氛课程工作台"
echo "  本地服务器一键启动脚本 (Linux)"
echo "═══════════════════════════════════════════════"
echo ""
echo "[1/4] ✓ Python 环境: $PYVER"
echo ""
echo "[2/4] ✓ 本机 IP: $LOCAL_IP"
echo ""
echo "[3/4] 🚀 启动本地服务器 (端口 $PORT)..."
echo ""
echo "═══════════════════════════════════════════════"
echo "  🚀 服务器已启动！"
echo "═══════════════════════════════════════════════"
echo ""
echo "  📱 本机访问:"
echo "     http://localhost:$PORT/"
echo ""
echo "  $LAN_MSG"
echo ""
echo "  📊 PPT 演示:"
echo "     http://localhost:$PORT/ppt-standalone.html"
echo ""
echo "  📋 材料清单:"
echo "     http://localhost:$PORT/materials.html"
echo ""
echo "═══════════════════════════════════════════════"
echo "  操作提示:"
echo "  • 按 Ctrl+C 停止服务器"
echo "  • 不要关闭此终端，否则服务器停止"
echo "═══════════════════════════════════════════════"
echo ""

# 尝试自动打开浏览器
echo "[4/4] 尝试打开浏览器..."
if command -v xdg-open &> /dev/null; then
    xdg-open "http://localhost:$PORT/" 2>/dev/null
    echo "      ✓ 浏览器已打开"
elif command -v open &> /dev/null; then
    open "http://localhost:$PORT/" 2>/dev/null
    echo "      ✓ 浏览器已打开"
else
    echo "      ⚠ 未找到浏览器自动打开工具，请手动访问"
fi
echo ""
echo "服务器运行中，按 Ctrl+C 停止..."
echo ""

# 启动服务器
$PYCMD -m http.server $PORT --bind 0.0.0.0
