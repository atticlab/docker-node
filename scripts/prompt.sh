#!/bin/bash
PEERS=""
VALIDATORS=""
IFS=","

rm ./.env-seed

read -p "Node seed: " INPUT
echo "NODE_SEED=$INPUT" >> ./.env-seed

read -ra ADDR -p "PREFERRED_PEERS (comma separated): "
for i in "${ADDR[@]}"; do
    PEERS+=\"${i// }\",
done
echo PREFERRED_PEERS="[${PEERS::-1}]" >> ./.env-seed


read -ra ADDR -p "VALIDATORS (comma separated): "
for i in "${ADDR[@]}"; do
    VALIDATORS+=\"${i// }\",
done
echo VALIDATORS="[${VALIDATORS::-1}]" >> ./.env-seed