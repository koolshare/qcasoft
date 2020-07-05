#! /bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
MODEL=$(nvram get productid)
module=shiptv
TITLE="上海电信IPTV"
DESCRIPTION="上海电信IPTV，4K IPTV 一键开启"
odmpid=$(nvram get odmpid)
LINUX_VER=$(cat /proc/version|awk '{print $3}'|awk -F"." '{print $1$2}')

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

# 安装前先关闭
[ "$shiptv_dhcp" == "1" -o "$shiptv_vlan" == "1" ] && sh /koolshare/scripts/shiptv_config.sh stop 2>/dev/null

# 安装插件
cp -rf /tmp/$module/scripts/* /koolshare/scripts/
cp -rf /tmp/$module/webs/* /koolshare/webs/
cp -rf /tmp/$module/res/* /koolshare/res/
cp -rf /tmp/$module/uninstall.sh /koolshare/scripts/uninstall_${module}.sh
chmod +x /koolshare/scripts/${module}*
chmod +x /koolshare/scripts/uninstall_${module}.sh

# 离线安装用
dbus set ${module}_version="$(cat $DIR/version)"
dbus set softcenter_module_${module}_version="$(cat $DIR/version)"
dbus set softcenter_module_${module}_description="${DESCRIPTION}"
dbus set softcenter_module_${module}_install="1"
dbus set softcenter_module_${module}_name="${module}"
dbus set softcenter_module_${module}_title="${TITLE}"

# 安装后需要开启
[ "$shiptv_dhcp" == "1" -o "$shiptv_vlan" == "1" ] && sh /koolshare/scripts/shiptv_config.sh start 2>/dev/null

# 完成
echo_date "【${TITLE}】插件安装完毕！"
exit_install
