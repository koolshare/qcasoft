#! /bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
MODEL=$(nvram get productid)
module=rog
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

# 安装插件
if [ ! -x /koolshare/bin/jq ]; then
	cp -f /tmp/rog/bin/jq /koolshare/bin/
	chmod +x /koolshare/bin/jq
fi
cp -rf /tmp/rog/scripts/* /koolshare/scripts/
cp -rf /tmp/rog/webs/* /koolshare/webs/
cp -rf /tmp/rog/res/* /koolshare/res/
if [ -n "$odmpid" -a "$odmpid" == "RAX80" ];then
	cp -rf /tmp/rog/init.d/* /koolshare/init.d/
fi
chmod +x /koolshare/scripts/rog*
chmod +x /koolshare/scripts/uninstall_rog.sh

# 离线安装用
dbus set rog_version="$(cat $DIR/version)"
dbus set softcenter_module_rog_version="$(cat $DIR/version)"
dbus set softcenter_module_rog_description="一些小功能的插件"
dbus set softcenter_module_rog_install="1"
dbus set softcenter_module_rog_name="rog"
dbus set softcenter_module_rog_title="ROG工具箱"

# 完成
echo_date "rog工具箱插件安装完毕！"
exit_install
