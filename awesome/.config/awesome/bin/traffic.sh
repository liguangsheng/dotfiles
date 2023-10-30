#!/bin/bash

interfaces=$(ip -o link show | awk -F': ' '{print $2}')

total_rx_bytes=0
total_tx_bytes=0

for interface in $interfaces; do
    rx_bytes=$(cat "/sys/class/net/$interface/statistics/rx_bytes")
    tx_bytes=$(cat "/sys/class/net/$interface/statistics/tx_bytes")
    total_rx_bytes=$((total_rx_bytes + rx_bytes))
    total_tx_bytes=$((total_tx_bytes + tx_bytes))
done

sleep 1s

for interface in $interfaces; do
    rx_bytes=$(cat "/sys/class/net/$interface/statistics/rx_bytes")
    tx_bytes=$(cat "/sys/class/net/$interface/statistics/tx_bytes")
    total_rx_bytes=$((total_rx_bytes - rx_bytes))
    total_tx_bytes=$((total_tx_bytes - tx_bytes))
done

echo "$((-total_rx_bytes + -total_tx_bytes))"

