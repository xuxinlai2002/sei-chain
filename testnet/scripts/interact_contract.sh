#!/bin/bash

# 设置环境变量
CHAIN_ID="sei-chain"
NODE="http://localhost:26657"
WALLET="my-wallet"
CONTRACT_ADDRESS=$(cat ../contracts/contract_address.txt)

# 存储数据
echo "存储数据..."
VALUE=42
TX_HASH=$(seid tx evm execute $CONTRACT_ADDRESS \
    $(echo -n "store(uint256)" | xxd -p) \
    $(printf "%064X" $VALUE) \
    --from $WALLET \
    --chain-id $CHAIN_ID \
    --node $NODE \
    --gas auto \
    --gas-adjustment 1.3 \
    -y | jq -r '.txhash')

echo "交易哈希: $TX_HASH"
echo "等待交易确认..."
sleep 5

# 读取数据
echo "读取数据..."
RESULT=$(seid query evm raw-call $CONTRACT_ADDRESS \
    $(echo -n "retrieve()" | xxd -p) \
    --node $NODE)

echo "存储的值: $RESULT" 