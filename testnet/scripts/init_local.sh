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

# 获取验证者地址
VALIDATOR_ADDR=$(seid keys show ${KEY_NAME} -a --keyring-backend test --home "$PROJECT_ROOT/testnet/.sei")

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
max_num_inbound_peers = 0
max_num_outbound_peers = 0
unconditional_peer_ids = ""
persistent_peers_max_dial_period = "0s"
flush_throttle_timeout = "10ms"
max_packet_msg_payload_size = 1024
send_rate = 0
recv_rate = 0
pex = false
seed_mode = false
private_peer_ids = ""

[mempool]
size = 10000
cache_size = 20000
max_txs_bytes = 1073741824
max_tx_bytes = 1048576
max_gas_wanted_per_tx = "50000000"
max_gas_used_per_block = "100000000"
recheck = true
broadcast = true

[consensus]
wal_file = "data/cs.wal/wal"
timeout_propose = "200ms"
timeout_propose_delta = "100ms"
timeout_prevote = "100ms"
timeout_prevote_delta = "100ms"
timeout_precommit = "100ms"
timeout_precommit_delta = "100ms"
timeout_commit = "100ms"
double_sign_check_height = 0
skip_timeout_commit = true
create_empty_blocks = true
create_empty_blocks_interval = "200ms"
peer_gossip_sleep_duration = "10ms"
peer_query_maj23_sleep_duration = "2s"
block_sync = false
fast_sync = false
validator_update_interval = 0

[tx_index]
indexer = "kv"

[blockchain]
fast_sync = false
block_sync = false
max_peer_height = 0
max_block_height = 0
max_block_time = "0s"
max_block_size = 0
max_block_gas = 0
max_block_txs = 0
max_block_parts = 0
max_block_evidence = 0
max_block_consensus = 0
max_block_validators = 0
max_block_proposer = 0
max_block_height_diff = 0
max_block_time_diff = "0s"
max_block_height_sync = 0
max_block_time_sync = "0s"
max_block_height_catchup = 0
max_block_time_catchup = "0s"
max_block_height_timeout = 0
max_block_time_timeout = "0s"
max_block_height_retry = 0
max_block_time_retry = "0s"

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
ws_port = 0
simulation_gas_limit = 10000000
simulation_evm_timeout = "60s"
cors_origins = "*"
ws_origins = "*"
max_tx_pool_txs = 1000
params = { chain_id = "32383" }

[validator]
name = "validator"
pub_key = "seivaloper1t0tkgd27eyyy2hdg8y3g5gwrhnc206p595959e"
power = "1000000000"
voting_power = "1000000000"
proposer_priority = 1000

[genesis]
chain_id = "Agt-2"
app_state = { validators = [{ pub_key = "seivaloper1t0tkgd27eyyy2hdg8y3g5gwrhnc206p595959e", power = "1000000000" }] }
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
ws_port = 0
simulation_gas_limit = 10000000
simulation_evm_timeout = "60s"
cors_origins = "*"
ws_origins = "*"
max_tx_pool_txs = 1000
params = { chain_id = "32383" }
EOF

echo "初始化完成！" 