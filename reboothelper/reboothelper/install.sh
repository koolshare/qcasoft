#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
module=reboothelper
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
cp -rf /tmp/reboothelper/scripts/* /koolshare/scripts/
cp -rf /tmp/reboothelper/webs/* /koolshare/webs/
cp -rf /tmp/reboothelper/res/* /koolshare/res/
cp -rf /tmp/reboothelper/uninstall.sh /koolshare/scripts/uninstall_reboothelper.sh

chmod +x /koolshare/scripts/reboothelper*
chmod +x /koolshare/scripts/uninstall_reboothelper.sh
[ -L "/koolshare/init.d/S99Reboothelper.sh" ] && rm -rf /koolshare/init.d/S99Reboothelper.sh
[ ! -L "/koolshare/init.d/V99Reboothelper.sh" ] && ln -sf /koolshare/scripts/reboothelper_config.sh /koolshare/init.d/V99Reboothelper.sh
chmod +x /koolshare/init.d/*

# 离线安装用
dbus set reboothelper_version="$(cat $DIR/version)"
dbus set softcenter_module_reboothelper_version="$(cat $DIR/version)"
dbus set softcenter_module_reboothelper_description="解决重启Bug"
dbus set softcenter_module_reboothelper_install="1"
dbus set softcenter_module_reboothelper_name="reboothelper"
dbus set softcenter_module_reboothelper_title="重启助手"

# 完成
echo_date "重启助手安装完毕！"
exit_install
