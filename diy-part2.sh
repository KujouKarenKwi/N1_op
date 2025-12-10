#!/bin/bash
# Description: OpenWrt DIY script part 2 (After Update feeds)

# --- 0. 编译环境修复 (解决 gn 编译失败) ---
# 修复 gn 源码下载问题，切换到 Github 源 (针对 gn [host] failed to build 错误)
find feeds/packages -name "Makefile" | xargs grep -l "PKG_SOURCE_URL.*googlesource.com" | xargs sed -i 's/googlesource.com/github.com/g'

# 强制 Python 软链接 (防止部分旧脚本找不到 python)
ln -sf /usr/bin/python3 /usr/bin/python

# ------------------------------------------------

# 1. 基础修正
# 修改默认 IP
sed -i 's/192.168.1.1/10.10.10.10/g' package/base-files/files/bin/config_generate
# 修改主机名
sed -i 's/OpenWrt/Phicomm-N1/g' package/base-files/files/bin/config_generate
# 设置默认主题为 Argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 2. 核心网络配置 (uci-defaults)
cat > package/base-files/files/etc/uci-defaults/99-custom-settings <<EOF
# --- 网络配置 ---
uci set network.lan.proto='static'
uci set network.lan.ipaddr='10.10.10.10'
uci set network.lan.netmask='255.255.255.0'
uci set network.lan.gateway='10.10.10.1'
# 设置两个 DNS
uci set network.lan.dns='10.10.10.1 223.5.5.5'

# --- 旁路由防火墙修正 (重要) ---
# 添加自定义防火墙规则，解决部分设备无法上网问题
echo "iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE" >> /etc/firewall.user

# --- 关闭 DHCP ---
uci set dhcp.lan.ignore='1'

# --- 关闭 IPv6 (彻底禁用) ---
uci set network.lan.ipv6='0'
uci set dhcp.lan.dhcpv6='disabled'
uci delete dhcp.lan.ra
uci delete dhcp.lan.ra_service
uci delete dhcp.lan.ndp
uci delete network.globals.ula_prefix

# --- Docker 优化 ---
# 自动挂载 Docker 数据分区 (如果 N1 已扩容分区)
uci set dockerd.globals.data_root='/opt/docker'

# 提交修改
uci commit network
uci commit dhcp
uci commit dockerd
/etc/init.d/odhcpd disable
/etc/init.d/odhcpd stop
exit 0
EOF
