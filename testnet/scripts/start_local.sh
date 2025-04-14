#!/bin/bash

# 检查是否已初始化
if [ ! -d "../.sei" ]; then
    echo "节点未初始化，正在初始化..."
    ./init_local.sh
fi

echo "正在启动节点..."
seid start \
    --home ../.sei \
    --rpc.laddr tcp://0.0.0.0:26657 \
    --p2p.laddr tcp://0.0.0.0:26656 \
    --grpc.address 0.0.0.0:9090 \
    --grpc-web.address 0.0.0.0:9091 \
    --minimum-gas-prices 0.0001usei \
    --p2p.pex=false \
    --p2p.persistent-peers="" \
    --mode validator 