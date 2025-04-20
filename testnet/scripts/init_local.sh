#!/bin/bash

# 设置变量
CHAIN_ID="Agt-2"
MONIKER="my-local-testnet"
KEY_NAME="validator"
KEY_2_NAME="user1"
CHAINFLAG="--chain-id ${CHAIN_ID}"
TOKEN_AMOUNT="10000000000000000000usei"
STAKING_AMOUNT="1000000000usei"

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

# 确保目录存在
mkdir -p "$PROJECT_ROOT/testnet/.sei"

# 删除之前的数据
rm -rf "$PROJECT_ROOT/testnet/.sei"/*

# 初始化链
seid init ${MONIKER} ${CHAINFLAG} --home "$PROJECT_ROOT/testnet/.sei"

# 创建验证人账户
seid keys add ${KEY_NAME} --keyring-backend test --home "$PROJECT_ROOT/testnet/.sei"
seid keys add ${KEY_2_NAME} --keyring-backend test --home "$PROJECT_ROOT/testnet/.sei"

# 添加创世账户
seid add-genesis-account $(seid keys show ${KEY_NAME} -a --keyring-backend test --home "$PROJECT_ROOT/testnet/.sei") ${TOKEN_AMOUNT} --home "$PROJECT_ROOT/testnet/.sei"
seid add-genesis-account $(seid keys show ${KEY_2_NAME} -a --keyring-backend test --home "$PROJECT_ROOT/testnet/.sei") ${TOKEN_AMOUNT} --home "$PROJECT_ROOT/testnet/.sei"

# 创建创世交易
seid gentx ${KEY_NAME} ${STAKING_AMOUNT} ${CHAINFLAG} --keyring-backend test --home "$PROJECT_ROOT/testnet/.sei"

# 收集创世交易
seid collect-gentxs --home "$PROJECT_ROOT/testnet/.sei"

# 验证创世文件
seid validate-genesis --home "$PROJECT_ROOT/testnet/.sei"

# 配置 config.toml
cat > "$PROJECT_ROOT/testnet/.sei/config/config.toml" << EOF
# This is a TOML config file.
# For more information, see https://github.com/toml-lang/toml

proxy-app = "tcp://127.0.0.1:26658"
moniker = "my-local-testnet"
mode = "validator"
fast_sync = false
db-backend = "goleveldb"
db-dir = "data"
log-level = "info"
log-format = "plain"

[rpc]
laddr = "tcp://0.0.0.0:26657"
cors_allowed_origins = ["*"]
cors_allowed_methods = ["HEAD", "GET", "POST"]
cors_allowed_headers = ["Origin", "Accept", "Content-Type", "X-Requested-With", "X-Server-Time"]

[p2p]
laddr = "tcp://0.0.0.0:26656"
external_address = ""
seeds = ""
persistent_peers = ""
upnp = false
addr_book_strict = false
max_num_inbound_peers = 10
max_num_outbound_peers = 10
unconditional_peer_ids = ""
persistent_peers_max_dial_period = "0s"
flush_throttle_timeout = "10ms"
max_packet_msg_payload_size = 1024
send_rate = 20480000
recv_rate = 20480000
pex = true
seed_mode = false
private_peer_ids = ""

[mempool]
size = 10000
cache_size = 20000
max_txs_bytes = 1073741824
max_tx_bytes = 1048576
max_gas_wanted_per_tx = "50000000"
max_gas_used_per_block = "100000000"

[consensus]
wal_file = "data/cs.wal/wal"
timeout_propose = "3s"
timeout_propose_delta = "500ms"
timeout_prevote = "1s"
timeout_prevote_delta = "500ms"
timeout_precommit = "1s"
timeout_precommit_delta = "500ms"
timeout_commit = "1s"
double_sign_check_height = 0
skip_timeout_commit = false
create_empty_blocks = true
create_empty_blocks_interval = "0s"
peer_gossip_sleep_duration = "10ms"
peer_query_maj23_sleep_duration = "2s"

[tx_index]
indexer = "kv"
EOF

# 配置 app.toml
cat > "$PROJECT_ROOT/testnet/.sei/config/app.toml" << EOF
minimum-gas-prices = "0.0001usei"
pruning = "nothing"
pruning-keep-recent = "0"
pruning-keep-every = "0"
pruning-interval = "0"
halt-height = 0
halt-time = 0
min-retain-blocks = 0
inter-block-cache = true
index-events = []
iavl-cache-size = 781250
iavl-disable-fastnode = false

[api]
enable = true
swagger = true
address = "tcp://0.0.0.0:1317"
max-open-connections = 1000
rpc-read-timeout = 10
rpc-write-timeout = 0
rpc-max-body-bytes = 1000000
enabled-unsafe-cors = true

[grpc]
enable = true
address = "0.0.0.0:9090"

[grpc-web]
enable = true
address = "0.0.0.0:9091"
enable-unsafe-cors = true

[state-sync]
snapshot-interval = 0
snapshot-keep-recent = 2

[telemetry]
enabled = false
global-labels = []

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
simulation_gas_limit = 10000000
simulation_evm_timeout = "60s"
cors_origins = "*"
ws_origins = "*"
max_tx_pool_txs = 1000
params = { chain_id = "32383" }
EOF

echo "初始化完成！" 