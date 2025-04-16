#!/bin/bash

echo "获取验证者(validator)信息："
echo "------------------------"
echo "Cosmos地址："
seid keys show validator -a --keyring-backend test --home ../.sei
echo "私钥："
seid keys export validator --keyring-backend test --home ../.sei --unarmored-hex --unsafe

echo -e "\n获取用户(user1)信息："
echo "------------------------"
echo "Cosmos地址："
seid keys show user1 -a --keyring-backend test --home ../.sei
echo "私钥："
seid keys export user1 --keyring-backend test --home ../.sei --unarmored-hex --unsafe 