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
prompt="${OS_NAME}: ${combined_text}"

# 输出问题
echo "$prompt"

# 定义请求 URL 和请求数据
APP_ID="f24d39cef70f42e5bfdd66df1c24485c"
API_KEY="sk-7ca572acd89f47228771435077beac75"
URL="https://dashscope.aliyuncs.com/api/v1/apps/${APP_ID}/completion"

DATA=$(cat <<EOF
{
"input": {
"prompt": "${prompt}"
},
"parameters": {},
"debug": {}
}
EOF
)

# 发送 HTTP POST 请求
RESPONSE=$(curl -s -X POST "$URL" \
    -H "Content-Type: application/json" \
    -H "Authorization: $API_KEY" \
    -d "$DATA")

# 使用 jq 提取 output.text
TEXT=$(echo "$RESPONSE" | jq -r '.output.text')

# 检查是否成功提取文本
if [ -n "$TEXT" ]; then
    echo "数据获取成功！"
    # echo "$TEXT"
else
    echo "请求异常，请重试或联系管理员"
    echo "$RESPONSE"
fi

# 按行分割文本，并为每一行添加序号
echo "下面是你可能想要执行的命名:"
IFS=$'\n' read -rd '' -a lines <<<"$TEXT"
for i in "${!lines[@]}"; do
    echo "$((i + 1)). ${lines[i]}"
done

# 提示用户输入序号
while true; do
    read -p "输入序号执行脚本 (或者输入 q 退出): " choice
    if [[ "$choice" == "q" ]]; then
        echo "Goodbye!"
        exit 0
    elif [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#lines[@]}" ]; then
        command="${lines[choice-1]}"
        echo "执行命令: $command"
        eval "$command"
    else
        echo "你输入的序号不正确，请重新输入，或者输入 q 退出:"
    fi
done