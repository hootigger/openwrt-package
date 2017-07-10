#!/bin/sh
echo
echo " Copyright (c) 2014-2017,by clion007"
echo " 本脚本仅用于个人研究与学习使用，从未用于产生任何盈利（包括“捐赠”等方式）"
echo " 未经许可，请勿内置于软件内发布与传播！请勿用于产生盈利活动！请遵守当地法律法规，文明上网。"
echo
#LOGFILE=/tmp/fqad_update.log
#LOGSIZE=$(wc -c < $LOGFILE)
#if [ $LOGSIZE -ge 5000 ]; then
#	sed -i -e 1,10d $LOGFILE
#fi
echo -e "\e[1;36m 3秒钟后开始更新规则\e[0m"
echo
sleep 3
echo " 开始更新dnsmasq规则"
# 下载sy618扶墙规则
/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/sy618 https://raw.githubusercontent.com/sy618/hosts/master/dnsmasq/dnsfq
# 下载racaljk规则
/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/racaljk https://raw.githubusercontent.com/racaljk/hosts/master/dnsmasq.conf
# 下载vokins广告规则
/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/ad.conf https://raw.githubusercontent.com/vokins/yhosts/master/dnsmasq/union.conf
# 下载easylistchina广告规则
/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/easylistchina.conf https://c.nnjsx.cn/GL/dnsmasq/update/adblock/easylistchina.txt

# 删除racaljk规则中google相关规则
#sed -i '/google/d' /tmp/racaljk
#sed -i '/youtube/d' /tmp/racaljk

# 创建用户自定规则缓存
cp /etc/dnsmasq.d/userlist /tmp/userlist

# 删除注释
sed -i '/#/d' /tmp/sy618
sed -i '/#/d' /tmp/racaljk
sed -i '/#/d' /tmp/ad.conf
sed -i '/#/d' /tmp/easylistchina.conf
sed -i '/#/d' /tmp/userlist

# 扶墙网站指定到#443端口访问
#awk '{print $0"#443"}' /tmp/sy618 > /tmp/sy618.conf
#awk '{print $0"#443"}' /tmp/racaljk > /tmp/racaljk.conf
#awk '{print $0"#443"}' /tmp/userlist > /tmp/userlist.conf

# 合并dnsmasq缓存
#cat /tmp/userlist /tmp/racaljk /tmp/sy618 /tmp/ad.conf /tmp/easylistchina.conf > /tmp/fqad
cat /tmp/sy618 > /tmp/fqad
#cat /tmp/userlist.conf /tmp/sy618.conf /tmp/ad.conf /tmp/easylistchina.conf > /tmp/fqad

# 删除dnsmasq缓存
rm -rf /tmp/userlist
#rm -rf /tmp/userlist.conf
rm -rf /tmp/ad.conf
rm -rf /tmp/sy618
#rm -rf /tmp/sy618.conf
rm -rf /tmp/easylistchina.conf
rm -rf /tmp/racaljk
#rm -rf /tmp/racaljk.conf

# 删除所有360和头条的规则
sed -i '/360/d' /tmp/fqad
sed -i '/toutiao/d' /tmp/fqad
sed -i '/taobao/d' /tmp/fqad
sed -i '/jd/d' /tmp/fqad

# 删除本地规则
sed -i '/localhost/d' /tmp/fqad
sed -i '/::1/d' /tmp/fqad

# 创建dnsmasq规则文件
cat > /tmp/fqad.conf <<EOF
############################################################
##【Copyright (c) 2014-2017, clion007】                           ##
##                                                                ##
## 感谢https://github.com/sy618/hosts                             ##
## 感谢https://github.com/racaljk/hosts                           ##
####################################################################

# Localhost (DO NOT REMOVE) Start
address=/localhost/127.0.0.1
address=/localhost/::1
address=/ip6-localhost/::1
address=/ip6-loopback/::1
# Localhost (DO NOT REMOVE) End

#Modified hosts start
EOF

# 删除dnsmasq重复规则
sort /tmp/fqad | uniq >> /tmp/fqad.conf

# 删除dnsmasq合并缓存
rm -rf /tmp/fqad
echo
echo " 开始更新hosts规则"
# 下载yhosts缓存
/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/yhosts.conf https://raw.githubusercontent.com/vokins/yhosts/master/hosts.txt
# 下载malwaredomainlist规则
/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/malwaredomainlist.conf http://www.malwaredomainlist.com/hostslist/hosts.txt
# 下载adaway规则缓存
/usr/bin/wget-ssl --no-check-certificate -q -O /tmp/adaway.conf http://77l5b4.com1.z0.glb.clouddn.com/hosts.txt

# 合并hosts缓存
#cat /tmp/yhosts.conf /tmp/adaway.conf /tmp/malwaredomainlist.conf > /tmp/noad
cat /tmp/yhosts.conf > /tmp/noad

# 删除hosts缓存
rm -rf /tmp/yhosts.conf
rm -rf /tmp/adaway.conf
rm -rf /tmp/malwaredomainlist.conf

# 删除所有360和头条的规则
sed -i '/360/d' /tmp/noad
sed -i '/toutiao/d' /tmp/noad
sed -i '/taobao/d' /tmp/noad
sed -i '/jd/d' /tmp/noad

# 删除注释及本地规则
sed -i '/#/d' /tmp/noad
sed -i '/@/d' /tmp/noad
sed -i '/::1/d' /tmp/noad
sed -i '/localhost/d' /tmp/noad
# 
#加入自定义域名
IPADDR=`uci get network.lan.ipaddr`
cat > /tmp/noad.conf <<EOF
############################################################
##【Copyright (c) 2014-2017, clion007】                           ##
##                                                                ##
## 感谢https://github.com/sy618/hosts                             ##
## 感谢https://github.com/vokins/hosts                            ##
## 感谢https://github.com/racaljk/hosts                           ##
####################################################################

#默认hosts开始（想恢复最初状态的hosts，只保留下面两行即可）
127.0.0.1 localhost
::1	localhost
::1	ip6-localhost
::1	ip6-loopback
#默认hosts结束
#自定义hosts
$IPADDR	guogh.com
$IPADDR	www.guogh.com
#自定义hosts结束

#修饰hosts开始
EOF

# 删除hosts重复规则
sort /tmp/noad | uniq >> /tmp/noad.conf

# 删除hosts合并缓存
rm -rf /tmp/noad
echo
if [ -s "/tmp/fqad.conf" ]; then
	if ( ! cmp -s /tmp/fqad.conf /etc/dnsmasq.d/fqad.conf ); then
		mv /tmp/fqad.conf /etc/dnsmasq.d/fqad.conf
		echo " `date +'%Y-%m-%d %H:%M:%S'`:检测到fqad规则有更新......开始转换规则！"
		/etc/init.d/dnsmasq restart >/dev/null 2>&1
		echo " `date +'%Y-%m-%d %H:%M:%S'`: fqad规则转换完成，应用新规则。"
		else
		echo " `date +'%Y-%m-%d %H:%M:%S'`: fqad本地规则和在线规则相同，无需更新！" && rm -f /tmp/fqad.conf
	fi	
fi
echo
if [ -s "/tmp/noad.conf" ]; then
	if ( ! cmp -s /tmp/noad.conf /etc/dnsmasq/noad.conf ); then
		mv /tmp/noad.conf /etc/dnsmasq/noad.conf
		echo " `date +'%Y-%m-%d %H:%M:%S'`: 检测到noad规则有更新......开始转换规则！"
		/etc/init.d/dnsmasq restart >/dev/null 2>&1
		echo " `date +'%Y-%m-%d %H:%M:%S'`: noad规则转换完成，应用新规则。"
		else
		echo " `date +'%Y-%m-%d %H:%M:%S'`: noad本地规则和在线规则相同，无需更新！" && rm -f /tmp/noad.conf
	fi	
fi
echo
echo -e "\e[1;36m 规则更新成功\e[0m"
echo
exit 0
