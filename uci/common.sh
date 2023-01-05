
while uci -q delete openclash.@dns_servers[0]; do :; done
while uci -q delete openclash.@config_subscribe[0]; do :; done

# 默认 SOCKS 不需要认证
while uci -q delete openclash.@authentication[0]; do :; done

uci batch << EOF

set system.@system[0].zonename='Asia/Shanghai'
set system.@system[0].timezone='CST-8'
set system.@system[0].cronloglevel='8'
set system.@system[0].conloglevel='7'

set luci.main.lang='zh_cn'

add openclash authentication
set openclash.@authentication[-1]=authentication
set openclash.@authentication[-1].enabled='0'

add openclash dns_servers
set openclash.@dns_servers[-1]=dns_servers
set openclash.@dns_servers[-1].group='nameserver'
set openclash.@dns_servers[-1].type='udp'
set openclash.@dns_servers[-1].enabled='1'
set openclash.@dns_servers[-1].ip='119.29.29.29'

add openclash config_subscribe
set openclash.@config_subscribe[-1]=config_subscribe
set openclash.@config_subscribe[-1].enabled='1'
set openclash.@config_subscribe[-1].address='CLASH_CONFIG_URL'
set openclash.@config_subscribe[-1].sub_convert='0'

set openclash.config.ipv6_enable='1'
set openclash.config.china_ip6_route='1'
set openclash.config.china_ip_route='1'
set openclash.config.geo_auto_update='1'
set openclash.config.geo_update_day_time='10'
set openclash.config.chnr_auto_update='1'
set openclash.config.auto_restart='1'
set openclash.config.auto_restart_day_time='3'
set openclash.config.enable_dns='1'
set openclash.config.ipv6_dns='1'
set openclash.config.append_wan_dns='0'
set openclash.config.disable_udp_quic='0'
set openclash.config.auto_update='1'
set openclash.config.config_auto_update_mode='0'
set openclash.config.config_update_week_time='*'

set openclash.config.core_type='Meta'
set openclash.config.enable_meta_core='1'
set openclash.config.enable_meta_sniffer='1'
set openclash.config.enable_meta_sniffer_custom='0'
set openclash.config.common_ports='1'
set openclash.config.append_default_dns='0'
set openclash.config.enable_custom_dns='1'

set network.lan.ipaddr='LAN_IP'
commit
EOF

mkdir -p /etc/dnsmasq.d/
echo "conf-dir=/etc/dnsmasq.d/" >> /etc/dnsmasq.conf