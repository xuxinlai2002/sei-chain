#!/bin/bash

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

# 检查节点是否已初始化
if [ ! -d "$PROJECT_ROOT/testnet/.sei" ]; then
    echo "节点未初始化，正在运行初始化脚本..."
    "$SCRIPT_DIR/init_local.sh"
fi

# 设置环境变量
export SEI_HOME="./.sei"
export SEI_CHAIN_ID="sei-local-1"

# 启动节点
echo "正在启动节点..."
seid start \
  --home $SEI_HOME \
  --chain-id $SEI_CHAIN_ID \
  --consensus.create-empty-blocks \
  --consensus.create-empty-blocks-interval="5s" \
  --p2p.upnp=false \
  --p2p.pex=false \
  --mode="validator" \
  --minimum-gas-prices="0.0001usei" \
  --moniker="local-testnet" \
  --log_level="info" \
  --rpc.laddr="tcp://0.0.0.0:26657" \
  --grpc.address="0.0.0.0:9090" \
  --grpc-web.address="0.0.0.0:9091" 