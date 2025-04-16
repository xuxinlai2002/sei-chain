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

[evm]
http_enabled = true
http_port = 8545
ws_enabled = true
ws_port = 8546
read_timeout = "30s"
read_header_timeout = "10s"
write_timeout = "30s"
idle_timeout = "120s"
simulation_gas_limit = 10000000
simulation_evm_timeout = "60s"
cors_origins = "*"
ws_origins = "*"
filter_timeout = "120s"
checktx_timeout = "5s"
max_tx_pool_txs = 1000
slow = false
deny_list = []
max_log_no_block = 10000
max_blocks_for_log = 2000
max_subscriptions_new_head = 10000
enable_test_api = false

[evm-log]
level = "debug"
module = ["eth", "evm", "vm", "state", "txpool"]
file = "../.sei/evm.log"
EOF

echo "初始化完成！" 