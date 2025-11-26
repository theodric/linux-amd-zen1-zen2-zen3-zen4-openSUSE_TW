#!/usr/bin/env bash
set -euo pipefail

# grabs the current mainline release candidate info from kernel.org's api
json=$(curl -s https://www.kernel.org/releases.json)

uri=$(echo "$json" \
    | jq -r '.releases[] | select(.moniker=="mainline") | .source')

file=$(basename "$uri")

echo "downloading $file"
aria2c -x16 --out="$file" "$uri"
