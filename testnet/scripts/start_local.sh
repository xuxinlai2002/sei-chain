#!/bin/bash

# 检查节点是否已初始化
if [ ! -d "../.sei" ]; then
    echo "节点未初始化，正在运行初始化脚本..."
    ./init_local.sh
fi

# 设置环境变量
export SEI_LOG_LEVEL=debug
export SEI_LOG_FORMAT=json

# 启动节点
echo "正在启动节点..."
seid start \
    --home ../.sei \
    --rpc.laddr tcp://0.0.0.0:26657 \
    --p2p.laddr tcp://0.0.0.0:26656 \
    --grpc.address 0.0.0.0:9090 \
    --grpc-web.address 0.0.0.0:9091 \
    --minimum-gas-prices 0.0001usei \
    --mode validator \
    --db-backend goleveldb \
    --p2p.pex=false \
    --p2p.persistent-peers="" \
    --consensus.create-empty-blocks=true \
    --consensus.create-empty-blocks-interval "5s" \
    --log_level debug \
    --trace 