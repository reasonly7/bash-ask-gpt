#!/bin/bash

# 检查是否提供了参数
if [ "$#" -eq 0 ]; then
    echo "你想问什么？"
    exit 1
fi

# 输出所有参数
echo "你的问题是："
for arg in "$@"; do
    echo "$arg"
done