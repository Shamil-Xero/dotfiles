#!/usr/bin/env bash
set -euo pipefail

# MATCH="CMF Buds 2a"
# MAC=$(bluetoothctl devices | grep -i "$MATCH" | awk '{print $2}' | head -n1)
MAC="2C:BE:EE:93:1E:A2"

echo "Removing $MAC (ignore errors if not currently paired)..."
bluetoothctl disconnect "$MAC" || true
bluetoothctl remove "$MAC" || true

echo "Put the buds in pairing mode now (hold button until LED flashes)."
echo "Scanning for 10 seconds..."

bluetoothctl --timeout 10 scan on

# Give bluez a moment to settle after scan stops
sleep 1

for i in 1 2 3; do
    echo "Pair attempt $i..."
    if bluetoothctl pair "$MAC"; then
        break
    fi
    sleep 2
done

bluetoothctl trust "$MAC"
bluetoothctl connect "$MAC"

echo "Done. Check status with: bluetoothctl info $MAC"