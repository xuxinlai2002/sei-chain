#!/bin/bash

# 检查节点状态
echo "检查节点状态..."
seid status

# 检查验证者信息
echo -e "\n检查验证者信息..."
seid query staking validators

# 检查最新区块
echo -e "\n检查最新区块..."
seid query block

# 检查网络信息
echo -e "\n检查网络信息..."
seid query tendermint-validator-set 