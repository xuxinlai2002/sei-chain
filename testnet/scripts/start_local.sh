#!/bin/bash

# 检查是否已经初始化
if [ ! -d "../.sei" ]; then
    echo "节点尚未初始化,正在执行初始化..."
    ./init_local.sh
fi

# 启动节点
echo "正在启动节点..."
seid start --home ../.sei \
  --rpc.laddr tcp://0.0.0.0:26657 \
  --grpc.address 0.0.0.0:9090 \
  --address tcp://0.0.0.0:26656 \
  --minimum-gas-prices 0.0001usei \
  --p2p.pex=false \
  --p2p.persistent-peers="" \
  --mode validator 