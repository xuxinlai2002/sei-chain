#!/bin/bash

# 设置变量
CHAIN_ID="sei-local-1"
MONIKER="my-local-testnet"
KEY_NAME="validator"
KEY_2_NAME="user1"
CHAINFLAG="--chain-id ${CHAIN_ID}"
TOKEN_AMOUNT="10000000000000000000usei"
STAKING_AMOUNT="1000000000usei"

# 确保目录存在
mkdir -p ../.sei

# 删除之前的数据
rm -rf ../.sei/*

# 初始化链
seid init ${MONIKER} ${CHAINFLAG} --home ../.sei

# 创建验证人账户
seid keys add ${KEY_NAME} --keyring-backend test --home ../.sei
seid keys add ${KEY_2_NAME} --keyring-backend test --home ../.sei

# 添加创世账户
seid add-genesis-account $(seid keys show ${KEY_NAME} -a --keyring-backend test --home ../.sei) ${TOKEN_AMOUNT} --home ../.sei
seid add-genesis-account $(seid keys show ${KEY_2_NAME} -a --keyring-backend test --home ../.sei) ${TOKEN_AMOUNT} --home ../.sei

# 创建创世交易
seid gentx ${KEY_NAME} ${STAKING_AMOUNT} ${CHAINFLAG} --keyring-backend test --home ../.sei

# 收集创世交易
seid collect-gentxs --home ../.sei

# 验证创世文件
seid validate-genesis --home ../.sei

echo "初始化完成！" 