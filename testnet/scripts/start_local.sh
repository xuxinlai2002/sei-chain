#!/bin/bash

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

# 检查节点是否已初始化
if [ ! -d "$PROJECT_ROOT/testnet/.sei" ]; then
    echo "节点尚未初始化，请先运行 init_local.sh"
    exit 1
fi

# 设置环境变量
export SEI_CHAIN_ID="32383"
export SEI_MONIKER="local-testnet"
export SEI_MIN_GAS_PRICES="0.0001usei"

# 启动节点
seid start --home="$PROJECT_ROOT/testnet/.sei" 