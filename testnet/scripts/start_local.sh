#!/bin/bash

# 设置变量
CHAIN_ID="sei-local-1"
CHAINFLAG="--chain-id ${CHAIN_ID}"

# 启动节点
seid start ${CHAINFLAG} \
  --home ../.sei \
  --rpc.laddr tcp://0.0.0.0:26657 \
  --grpc.address 0.0.0.0:9090 \
  --address tcp://0.0.0.0:26656 \
  --minimum-gas-prices 0.0001usei \
  --p2p.pex=false \
  --p2p.persistent-peers="" \
  --mode validator 