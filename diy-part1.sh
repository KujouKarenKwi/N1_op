#!/bin/bash
#
# [https://github.com/P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# 取消注释 helloworld (通常是 SSR+)
sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# 添加 Passwall 源 (强烈推荐)
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# 如果需要 OpenClash，可以取消下面这行的注释
echo 'src-git openclash https://github.com/vernesong/OpenClash' >>feeds.conf.default
