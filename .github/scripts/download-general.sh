#!/usr/bin/env bash
source "$(dirname "$0")/lib_fetch.sh"

echo "📦 Processing General Configs..."

TASKS=$(cat <<'EOF'
https://raw.githubusercontent.com/yiteei/Share/refs/heads/Proxy/config/redir-host.yaml|General_Config/Yiteei/redir-host_config.yaml
https://raw.githubusercontent.com/yiteei/Share/refs/heads/Proxy/config/fake-ip.yaml|General_Config/Yiteei/fake-ip_config.yaml
https://raw.githubusercontent.com/JohnsonRan/CRules/refs/heads/master/config/AIB.yaml|General_Config/JohnsonRan/AIB.yaml
https://raw.githubusercontent.com/JohnsonRan/CRules/refs/heads/master/config/AIO.yaml|General_Config/JohnsonRan/AIO.yaml
https://raw.githubusercontent.com/666OS/YYDS/main/mihomo/config/MihomoPro.yaml|General_Config/666OS/MihomoPro_Config.yaml
https://raw.githubusercontent.com/666OS/YYDS/main/mihomo/config/OneTouch.yaml|General_Config/666OS/OneTouch_Config.yaml
https://raw.githubusercontent.com/HenryChiao/MIHOMO_AIO/refs/heads/main/CONFIG/General/MihomoAIO.yaml|General_Config/HenryChiao/MihomoAIO.yaml
https://raw.githubusercontent.com/HenryChiao/MIHOMO_AIO/refs/heads/main/CONFIG/General/MihomoProMax.yaml|General_Config/HenryChiao/MihomoProMax.yaml
https://raw.githubusercontent.com/HenryChiao/MIHOMO_AIO/refs/heads/main/CONFIG/General/MihomoProPlus.yaml|General_Config/HenryChiao/MihomoProPlus.yaml
https://raw.githubusercontent.com/yyhhyyyyyy/selfproxy/refs/heads/main/Mihomo/mihomo_single.yaml|General_Config/yyhhyyyyyy/mihomo_single.yaml
https://raw.githubusercontent.com/yyhhyyyyyy/selfproxy/refs/heads/main/Mihomo/mihomo_multi.yaml|General_Config/yyhhyyyyyy/mihomo_multi.yaml
https://raw.githubusercontent.com/liandu2024/little/refs/heads/main/yaml/clash-fallback.yaml|General_Config/liandu2024/clash-fallback.yaml
https://raw.githubusercontent.com/liandu2024/little/refs/heads/main/yaml/clash-fallback-std.yaml|General_Config/liandu2024/clash-fallback-std.yaml
https://raw.githubusercontent.com/liandu2024/little/refs/heads/main/yaml/clash-fallback-dialer.yaml|General_Config/liandu2024/clash-fallback-dialer.yaml
https://raw.githubusercontent.com/liandu2024/little/refs/heads/main/yaml/clash-fallback-all.yaml|General_Config/liandu2024/clash-fallback-all.yaml
https://raw.githubusercontent.com/liandu2024/little/refs/heads/main/yaml/clash-all-fallback.yaml|General_Config/liandu2024/clash-all-fallback.yaml
https://raw.githubusercontent.com/ClashConnectRules/Self-Configuration/refs/heads/main/Clash.yaml|General_Config/ClashConnectRules/Clash.yaml
https://raw.githubusercontent.com/Lanlan13-14/Rules/refs/heads/main/configfull.yaml|General_Config/Lanlan13-14/configfull.yaml
https://raw.githubusercontent.com/Lanlan13-14/Rules/refs/heads/main/configfull_lite.yaml|General_Config/Lanlan13-14/configfull_lite.yaml
https://raw.githubusercontent.com/Lanlan13-14/Rules/refs/heads/main/configfull_NoAd.yaml|General_Config/Lanlan13-14/configfull_NoAd.yaml
https://raw.githubusercontent.com/echs-top/proxy/heads/main/mihomo.yaml|General_Config/echs-top/mihomo.yaml
https://raw.githubusercontent.com/qichiyuhub/rule/refs/heads/main/config/mihomo/config.yaml|General_Config/qichiyuhub/config.yaml
https://raw.githubusercontent.com/luestr/ProxyResource/main/Tool/Clash/Config/Clash_Sample_Config_By_iKeLee.yaml|General_Config/iKeLee/Clash_Sample.yaml
https://raw.githubusercontent.com/sunfing/iNg/refs/heads/main/Config/ConfigForClash|General_Config/fufu/ConfigForClash.yaml
https://gist.githubusercontent.com/liuran001/5ca84f7def53c70b554d3f765ff86a33/raw/9de058af0600fbbcfb480f9cbc23bd7dafe9d039/config.yaml|General_Config/liuran001/config.yaml
https://raw.githubusercontent.com/wanswu/my-backup/refs/heads/main/clash/config.yaml|General_Config/wanswu/config.yaml
EOF
)

run_parallel_tasks "$TASKS" 6
