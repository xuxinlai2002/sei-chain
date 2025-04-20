#!/bin/bash

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

# 检查节点是否已初始化
if [ ! -d "$PROJECT_ROOT/testnet/.sei" ]; then
    echo "节点尚未初始化，正在运行 init_local.sh..."
    ./testnet/scripts/init_local.sh
fi

# 设置环境变量
export SEI_CHAIN_ID="32383"
export SEI_MONIKER="local-testnet"
export SEI_MIN_GAS_PRICES="0.0001usei"

# 停止当前运行的节点（如果存在）
pkill seid || true

# 等待进程完全停止
sleep 1

# 确保没有遗留的 seid 进程
while pgrep seid > /dev/null; do
    echo "等待 seid 进程完全停止..."
    pkill seid
    sleep 2
done

# 启动节点
seid start --home="$PROJECT_ROOT/testnet/.sei" --log_level info --log_format plain 