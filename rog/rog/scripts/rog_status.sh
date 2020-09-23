#!/bin/sh

#alias echo_date='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
model=$(nvram get productid)
#=================================================

# CPU温度
cpu_temperature_origin=$(cat /sys/class/thermal/thermal_zone0/temp)
cpu_temperature="CPU：$(awk 'BEGIN{printf "%.0f\n",('$cpu_temperature_origin')}')°C"

#网卡温度
WIFI_2G_DISABLE=$(iwconfig ath1|grep "Not-Associated")
WIFI_5G_DISABLE=$(iwconfig ath0|grep "Not-Associated")

interface_2g_temperature=$(thermaltool -i wifi1 -get|sed -n 's/.*temperature: \([0-9][0-9]\).*/\1/p') 2>/dev/null
interface_5g1_temperature=$(thermaltool -i wifi0 -get|sed -n 's/.*temperature: \([0-9][0-9]\).*/\1/p') 2>/dev/null
[ -z "${WIFI_2G_DISABLE}" ] && interface_2g_temperature_c="${interface_2g_temperature}°C" || interface_2g_temperature_c="offline"
[ -z "${WIFI_5G_DISABLE}" ] && interface_5g1_temperature_c="${interface_5g1_temperature}°C" || interface_5g1_temperature_c="offline"
wl_temperature="2.4G：${interface_2g_temperature_c} &nbsp;&nbsp;|&nbsp;&nbsp; 5G：${interface_5g1_temperature_c}"

interface_2g_power=$(iwconfig ath1|sed -n 's/.*Tx-Power.*\([0-9][0-9]\).*/\1/p') 2>/dev/null
interface_5g1_power=$(iwconfig ath0|sed -n 's/.*Tx-Power.*\([0-9][0-9]\).*/\1/p') 2>/dev/null
[ -z "${WIFI_2G_DISABLE}" ] && interface_2g_power_d="${interface_2g_power} dBm" || interface_2g_power_d="offline"
[ -z "${WIFI_2G_DISABLE}" ] && interface_2g_power_p="$(awk -v x=${interface_2g_power} 'BEGIN { printf "%.2f\n", 10^(x/10)}') mw" || interface_2g_power_p="offline"
[ -z "${WIFI_5G_DISABLE}" ] && interface_5g1_power_d="${interface_5g1_power} dBm" || interface_5g1_power_d="offline"
[ -z "${WIFI_5G_DISABLE}" ] && interface_5g1_power_p="$(awk -v x=${interface_5g1_power} 'BEGIN { printf "%.2f\n", 10^(x/10)}') mw" || interface_5g1_power_p="offline"
wl_txpwr="2.4G：${interface_2g_power_d} / ${interface_2g_power_p} <br /> 5G：&nbsp;&nbsp;&nbsp;${interface_5g1_power_d} / ${interface_5g1_power_p}"
#=================================================
http_response "${cpu_temperature}@@${wl_temperature}@@${wl_txpwr}"
