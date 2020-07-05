#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
module=routerhook
DIR=$(
    cd $(dirname $0)
    pwd
)

# 获取固件类型
_get_type() {
    local FWTYPE=$(nvram get extendno | grep koolshare)
    if [ -d "/koolshare" ]; then
        if [ -n $FWTYPE ]; then
            echo "koolshare官改固件"
        else
            echo "koolshare梅林改版固件"
        fi
    else
        if [ "$(uname -o | grep Merlin)" ]; then
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

echo_date "STOP RouterHook FIRST"

# stop routerhook first
enable=$(dbus get routerhook_enable)
if [ "$enable" == "1" ] && [ -f "/koolshare/scripts/routerhook_config.sh" ]; then
    /koolshare/scripts/routerhook_config.sh stop >/dev/null 2>&1
fi

# 安装
echo_date "开始安装RouterHook通知回调..."
cd /tmp
if [[ ! -x /koolshare/bin/jq ]]; then
    cp -f /tmp/routerhook/bin/jq /koolshare/bin/jq
    chmod +x /koolshare/bin/jq
fi
rm -rf /koolshare/init.d/*routerhook.sh
rm -rf /koolshare/routerhook >/dev/null 2>&1
rm -rf /koolshare/scripts/routerhook_*
cp -rf /tmp/routerhook/res/icon-routerhook.png /koolshare/res/
cp -rf /tmp/routerhook/scripts/* /koolshare/scripts/
cp -rf /tmp/routerhook/webs/Module_routerhook.asp /koolshare/webs/
chmod +x /koolshare/scripts/*
# 安装重启自动启动功能
[ ! -L "/koolshare/init.d/S99CRUrouterhook.sh" ] && ln -sf /koolshare/scripts/routerhook_config.sh /koolshare/init.d/S99CRUrouterhook.sh

# 设置默认值
router_name=$(echo $(nvram get model) | base64_encode)
router_name_get=$(dbus get routerhook_config_name)
if [ -z "${router_name_get}" ]; then
    dbus set routerhook_config_name="${router_name}"
fi
router_ntp_get=$(dbus get routerhook_config_ntp)
if [ -z "${router_ntp_get}" ]; then
    dbus set routerhook_config_ntp="ntp1.aliyun.com"
fi
bwlist_en_get=$(dbus get routerhook_dhcp_bwlist_en)
if [ -z "${bwlist_en_get}" ]; then
    dbus set routerhook_dhcp_bwlist_en="1"
fi
_sckey=$(dbus get routerhook_config_sckey)
if [ -n "${_sckey}" ]; then
    dbus set routerhook_config_sckey_1=$(dbus get routerhook_config_sckey)
    dbus remove routerhook_config_sckey
fi
[ -z "$(dbus get routerhook_info_lan_macoff)" ] && dbus set routerhook_info_lan_macoff="1"
[ -z "$(dbus get routerhook_info_dhcp_macoff)" ] && dbus set routerhook_info_dhcp_macoff="1"
[ -z "$(dbus get routerhook_trigger_dhcp_macoff)" ] && dbus set routerhook_trigger_dhcp_macoff="1"

# 离线安装用
dbus set routerhook_version="$(cat $DIR/version)"
dbus set softcenter_module_routerhook_version="$(cat $DIR/version)"
dbus set softcenter_module_routerhook_install="1"
dbus set softcenter_module_routerhook_name="routerhook"
dbus set softcenter_module_routerhook_title="RouterHook通知回调"
dbus set softcenter_module_routerhook_description="从路由器推送状态及通知的工具。"

# re-enable routerhook
if [ "$enable" == "1" ] && [ -f "/koolshare/scripts/routerhook_config.sh" ]; then
    /koolshare/scripts/routerhook_config.sh start >/dev/null 2>&1
fi

# 完成
echo_date "routerhook通知回调插件安装完毕！"
exit_install
