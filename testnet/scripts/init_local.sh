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

# 配置 memiavl store
cat > ../.sei/config/app.toml << EOF
[state-commit]
sc-enable = true
sc-zero-copy = false
sc-async-commit-buffer = 100
sc-keep-recent = 1
sc-snapshot-interval = 10000
sc-snapshot-writer-limit = 2
sc-cache-size = 100000

[state-store]
ss-enable = true
ss-backend = "pebbledb"
ss-async-write-buffer = 100
ss-keep-recent = 100000
ss-prune-interval = 600
ss-import-num-workers = 1
EOF

echo "初始化完成！" 