#!/bin/bash
# Description: OpenWrt DIY script part 1 (Before Update feeds)

# 1. 添加 Passwall 源 (依赖和主程序)
echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages' >>feeds.conf.default
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# 2. 添加 OpenClash 源
echo 'src-git openclash https://github.com/vernesong/OpenClash' >>feeds.conf.default

# 3. 添加 Argon 主题源码 (Jerrykuku版本，比官方源更好看且支持自定义)
# 先移除可能存在的旧 argon 引用，防止冲突
rm -rf package/lean/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# 4. 添加 N1 专用 Amlogic 写入工具 (Ophub版本，用于写入 EMMC)
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
