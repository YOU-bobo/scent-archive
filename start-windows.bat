@echo off
chcp 65001 >nul
title 气味档案室 · AI香氛课程工作台 - 本地服务器
color 0A

echo ════════════════════════════════════════════════
echo   🌸 气味档案室 · AI香氛课程工作台
echo   本地服务器一键启动脚本 (Windows)
echo ════════════════════════════════════════════════
echo.

REM 切换到脚本所在目录
cd /d "%~dp0"

REM 检查 index.html 是否存在
if not exist "index.html" (
    echo [错误] 未找到 index.html 文件！
    echo 请确保此脚本与网站文件在同一文件夹。
    echo.
    pause
    exit /b 1
)

REM 检查 Python 是否安装
echo [1/4] 检查 Python 环境...
python --version >nul 2>&1
if %errorlevel% == 0 (
    for /f "tokens=*" %%i in ('python --version 2^>^&1') do set PYVER=%%i
    echo       ✓ 已安装: %PYVER%
    set PYCMD=python
) else (
    py --version >nul 2>&1
    if %errorlevel% == 0 (
        for /f "tokens=*" %%i in ('py --version 2^>^&1') do set PYVER=%%i
        echo       ✓ 已安装: %PYVER%
        set PYCMD=py
    ) else (
        echo       ✗ 未检测到 Python
        echo.
        echo 请先安装 Python:
        echo   1. 访问 https://www.python.org/downloads/
        echo   2. 下载 Python 3.x
        echo   3. 安装时勾选 "Add Python to PATH"
        echo.
        pause
        exit /b 1
    )
)
echo.

REM 获取本机 IP
echo [2/4] 获取本机 IP 地址...
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /C:"IPv4"') do (
    set LOCAL_IP=%%a
    set LOCAL_IP=!LOCAL_IP: =!
    goto :gotip
)
:gotip
if defined LOCAL_IP (
    echo       ✓ 本机 IP: %LOCAL_IP%
) else (
    set LOCAL_IP=127.0.0.1
    echo       ⚠ 未获取到局域网 IP，仅本机可访问
)
echo.

REM 选择端口
set PORT=8080
echo [3/4] 启动本地服务器 (端口 %PORT%)...
echo.
echo ════════════════════════════════════════════════
echo   🚀 服务器已启动！
echo ════════════════════════════════════════════════
echo.
echo   📱 本机访问:
echo      http://localhost:%PORT%/
echo.
echo   📱 局域网访问 (手机/平板同 WiFi):
echo      http://%LOCAL_IP%:%PORT%/
echo.
echo   📊 PPT 演示:
echo      http://localhost:%PORT%/ppt-standalone.html
echo.
echo   📋 材料清单:
echo      http://localhost:%PORT%/materials.html
echo.
echo   📖 本地部署指南:
echo      http://localhost:%PORT%/local-deploy.html
echo.
echo ════════════════════════════════════════════════
echo   操作提示:
echo   • 按 Ctrl+C 停止服务器
echo   • 不要关闭此窗口，否则服务器停止
echo   • 首次访问手机需同意电脑的防火墙请求
echo ════════════════════════════════════════════════
echo.

REM 自动打开浏览器
echo [4/4] 自动打开浏览器...
start "" "http://localhost:%PORT%/"
echo       ✓ 浏览器已打开
echo.
echo 服务器运行中，按 Ctrl+C 停止...
echo.

REM 启动服务器
%PYCMD% -m http.server %PORT% --bind 0.0.0.0
