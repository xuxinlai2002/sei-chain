#!/bin/bash

# 设置环境变量
CHAIN_ID="sei-chain"
NODE="http://localhost:26657"
WALLET="my-wallet"

# 编译合约
echo "编译智能合约..."
cd ../contracts
solc --abi --bin SimpleStorage.sol -o build

# 获取部署账户地址
ACCOUNT_ADDRESS=$(seid keys show $WALLET -a)
echo "部署账户地址: $ACCOUNT_ADDRESS"

# 部署合约
echo "部署合约..."
TX_HASH=$(seid tx evm deploy \
    $(cat build/SimpleStorage.bin) \
    --from $WALLET \
    --chain-id $CHAIN_ID \
    --node $NODE \
    --gas auto \
    --gas-adjustment 1.3 \
    -y | jq -r '.txhash')

echo "交易哈希: $TX_HASH"

# 等待交易确认
echo "等待交易确认..."
sleep 5

# 获取合约地址
CONTRACT_ADDRESS=$(seid query tx $TX_HASH --node $NODE -o json | jq -r '.logs[0].events[] | select(.type=="evm").attributes[] | select(.key=="contract_address").value')
echo "合约已部署到地址: $CONTRACT_ADDRESS"

# 保存合约地址供后续使用
echo $CONTRACT_ADDRESS > ../contracts/contract_address.txt 