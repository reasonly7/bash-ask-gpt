#!/bin/bash

# 检查是否提供了参数
if [ "$#" -eq 0 ]; then
    echo "你想问什么？"
    exit 1
fi

# 合并用户输入的参数成一个文本
combined_text="$*"

# 获取当前系统名称
OS_TYPE=$(uname)
case "$OS_TYPE" in
    "Linux")
        OS_NAME="linus"
        ;;
    "Darwin")
        OS_NAME="macos"
        ;;
    "CYGWIN"* | "MINGW"* | "MSYS"*)
        OS_NAME="windows"
        ;;
    *)
        OS_NAME="unknown"
        ;;
esac

# 合并文本和系统名称
output="${OS_NAME}: ${combined_text}"

# 输出结果
echo "$output"