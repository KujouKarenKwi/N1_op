#!/bin/bash
#
# [https://github.com/P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 1. 修改默认 IP 为 10.10.10.10 (这是第一层保障)
sed -i 's/192.168.1.1/10.10.10.10/g' package/base-files/files/bin/config_generate

# 2. 修改主机名为 ImmortalWrt-Side (可选，方便识别)
sed -i 's/OpenWrt/ImmortalWrt-Side/g' package/base-files/files/bin/config_generate

# 3. 设置默认主题为 Argon (ImmortalWrt 通常自带 Argon，设为默认更好看)
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 4. 创建自定义配置脚本 (核心部分：配置网关、DNS、关闭DHCP、关闭IPv6)
# 这个脚本会在系统第一次启动时执行
cat > package/base-files/files/etc/uci-defaults/99-custom-settings <<EOF
# --- 网络基础配置 ---
uci set network.lan.proto='static'
uci set network.lan.ipaddr='10.10.10.10'
uci set network.lan.netmask='255.255.255.0'
uci set network.lan.gateway='10.10.10.1'
uci set network.lan.dns='10.10.10.1'

# --- 关闭 DHCP ---
# 旁路由必须关闭 DHCP，否则会干扰主路由
uci set dhcp.lan.ignore='1'

# --- 关闭 IPv6 ---
# 删除 IPv6 相关接口和 DHCPv6 设置
uci set network.lan.ipv6='0'
uci set dhcp.lan.dhcpv6='disabled'
uci delete dhcp.lan.ra
uci delete dhcp.lan.ra_service
uci delete dhcp.lan.ndp
uci delete network.globals.ula_prefix

# 提交网络和DHCP修改
uci commit network
uci commit dhcp

# --- 禁用系统级 IPv6 服务 ---
/etc/init.d/odhcpd disable
/etc/init.d/odhcpd stop

exit 0
EOF
