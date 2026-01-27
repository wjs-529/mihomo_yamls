#!/usr/bin/env bash
source "$(dirname "$0")/lib_fetch.sh"

echo "📦 Processing Mobile Modules..."

TASKS=$(cat <<'EOF'
https://raw.githubusercontent.com/GitMetaio/Surfing/refs/heads/main/box_bll/clash/config.yaml|Mobile_Modules/Surfing/config.yaml
https://raw.githubusercontent.com/akashaProxy/akashaProxy/refs/heads/master/module/src/config.example.yaml|Mobile_Modules/AkashaProxy/config.yaml
https://raw.githubusercontent.com/AXEVO/Clash-MIX/refs/heads/Clash-MIX-4.0/Clash/Clash%E9%85%8D%E7%BD%AE.yaml|Mobile_Modules/ClashMix/config.yaml
https://raw.githubusercontent.com/boxproxy/box/refs/heads/master/box/mihomo/config.yaml|Mobile_Modules/BoxProxy/config.yaml
EOF
)

run_parallel_tasks "$TASKS" 4
