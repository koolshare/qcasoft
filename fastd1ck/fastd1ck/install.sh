#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
module=fastd1ck
DIR=$(cd $(dirname $0); pwd)

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

# 安装插件
find /koolshare/init.d/ -name "*fastd1ck*" | xargs rm -rf
find /koolshare/init.d/ -name "*FastD1ck*" | xargs rm -rf
cp -rf /tmp/fastd1ck/scripts/* /koolshare/scripts/
cp -rf /tmp/fastd1ck/webs/* /koolshare/webs/
cp -rf /tmp/fastd1ck/res/* /koolshare/res/
cp -rf /tmp/fastd1ck/uninstall.sh /koolshare/scripts/uninstall_fastd1ck.sh
chmod +x /koolshare/scripts/fastd1ck*.sh
chmod +x /koolshare/scripts/uninstall_fastd1ck.sh
[ ! -L "/koolshare/init.d/S99fastd1ck.sh" ] && ln -sf /koolshare/scripts/fastd1ck_config.sh /koolshare/init.d/S99fastd1ck.sh

# 离线安装用
dbus set fastd1ck_version="$(cat $DIR/version)"
dbus set softcenter_module_fastd1ck_version="$(cat $DIR/version)"
dbus set softcenter_module_fastd1ck_description="迅雷快鸟，上网必备神器"
dbus set softcenter_module_fastd1ck_install="1"
dbus set softcenter_module_fastd1ck_name="fastd1ck"
dbus set softcenter_module_fastd1ck_title="迅雷快鸟"

# re-enable fastd1ck
if [ "$enable" == "1" ];then
	[ -f "/koolshare/scripts/fastd1ck_config.sh" ] && sh /koolshare/scripts/fastd1ck_config.sh start
fi

# 完成
echo_date "迅雷快鸟插件安装完毕！"
exit_install
