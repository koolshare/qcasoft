#! /bin/sh
source /koolshare/scripts/base.sh
eval `dbus export koolproxy`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
module=koolproxy
MODEL=$(nvram get productid)
DIR=$(cd $(dirname $0); pwd)
mkdir -p /tmp/upload
touch /tmp/upload/kp_log.txt

# 获取固件类型
_get_type() {
	local FWTYPE=$(nvram get extendno|grep koolshare)
	if [ -d "/koolshare" ];then
		if [ -n $FWTYPE ];then
			echo "koolshare官改固件"
		else
			echo "koolshare梅林改版固件"
		fi
	else
		if [ "$(uname -o|grep Merlin)" ];then
			echo "梅林原版固件"
		else
			echo "华硕官方固件"
		fi
	fi
}

exit_install(){
	local state=$1
	case $state in
		1)
			echo_date "本插件适用于适用于【koolshare 官改 qca-ipq806x】固件平台，你的固件平台不能安装！！！"
			echo_date "本插件支持机型/平台：https://github.com/koolshare/qcasoft#qcasoft"
			echo_date "退出安装！"
			rm -rf /tmp/${module}* >/dev/null 2>&1
			exit 1
			;;
		0|*)
			rm -rf /tmp/${module}* >/dev/null 2>&1
			exit 0
			;;
	esac
}

# 判断路由架构和平台
case $(uname -m) in
	armv7l)
		if [ "$MODEL" == "RT-AX89U" ] && [ -d "/koolshare" ];then
			echo_date 机型：$MODEL $(_get_type) 符合安装要求，开始安装插件！
		else
			exit_install 1
		fi
		;;
	*)
		exit_install 1
	;;
esac

# stop koolproxy first
if [ "$koolproxy_enable" == "1" ] && [ -f "/koolshare/koolproxy/kp_config.sh" ];then
	sh /koolshare/koolproxy/kp_config.sh stop
fi

# remove old files, do not remove user.txt incase of upgrade
rm -rf /koolshare/bin/koolproxy >/dev/null 2>&1
rm -rf /koolshare/scripts/KoolProxy* >/dev/null 2>&1
rm -rf /koolshare/webs/Module_koolproxy.asp >/dev/null 2>&1
rm -rf /koolshare/res/icon-koolproxy.png >/dev/null 2>&1
rm -rf /koolshare/koolproxy/*.sh >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/dnsmasq.adblock >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/gen_ca.sh >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/koolproxy_ipset.conf >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/openssl.cnf >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/serial >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/version >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/rules/*.dat >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/rules/daily.txt >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/rules/koolproxy.txt >/dev/null 2>&1

# copy new files
cd /tmp
mkdir -p /koolshare/koolproxy
mkdir -p /koolshare/koolproxy/data
mkdir -p /koolshare/koolproxy/data/rules

cp -rf /tmp/koolproxy/scripts/* /koolshare/scripts/
cp -rf /tmp/koolproxy/webs/* /koolshare/webs/
cp -rf /tmp/koolproxy/res/* /koolshare/res/
if [ ! -f /koolshare/koolproxy/data/rules/user.txt ];then
	cp -rf /tmp/koolproxy/koolproxy /koolshare/
else
	mv /koolshare/koolproxy/data/rules/user.txt /tmp/user.txt.tmp
	cp -rf /tmp/koolproxy/koolproxy /koolshare/
	mv /tmp/user.txt.tmp /koolshare/koolproxy/data/rules/user.txt
fi
cp -f /tmp/koolproxy/uninstall.sh /koolshare/scripts/uninstall_koolproxy.sh
#[ ! -L "/koolshare/bin/koolproxy" ] && ln -sf /koolshare/koolproxy/koolproxy /koolshare/bin/koolproxy
chmod 755 /koolshare/koolproxy/*
chmod 755 /koolshare/koolproxy/data/*
chmod 755 /koolshare/scripts/*

# 创建开机启动文件
find /koolshare/init.d/ -name "*koolproxy*" | xargs rm -rf
[ ! -L "/koolshare/init.d/S98koolproxy.sh" ] && ln -sf /koolshare/koolproxy/kp_config.sh /koolshare/init.d/S98koolproxy.sh
[ ! -L "/koolshare/init.d/N98koolproxy.sh" ] && ln -sf /koolshare/koolproxy/kp_config.sh /koolshare/init.d/N98koolproxy.sh

# 设置默认值
[ -z "$koolproxy_mode" ] && dbus set koolproxy_mode=1
[ -z "$koolproxy_acl_default" ] && dbus set koolproxy_acl_default=1

# 离线安装用
dbus set koolproxy_version="$(cat $DIR/version)"
dbus set softcenter_module_koolproxy_version="$(cat $DIR/version)"
dbus set softcenter_module_koolproxy_install="1"
dbus set softcenter_module_koolproxy_name="koolproxy"
dbus set softcenter_module_koolproxy_title="KidsProtect"
dbus set softcenter_module_koolproxy_description="KP: Kids Protect，互联网内容过滤，保护未成年人上网~"

# restart
if [ "$koolproxy_enable" == "1" ] && [ -f "/koolshare/koolproxy/kp_config.sh" ];then
	sh /koolshare/koolproxy/kp_config.sh restart
fi
# 完成
echo_date "koolproxy插件安装完毕！"
exit_install
