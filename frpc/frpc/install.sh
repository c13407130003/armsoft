#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)

# 判断路由架构和平台
case $(uname -m) in
	armv7l)
		if [ "`uname -o|grep Merlin`" ] && [ -d "/koolshare" ] && [ -n "`nvram get buildno|grep 384`" ];then
			echo_date 固件平台【koolshare merlin armv7l 384】符合安装要求，开始安装插件！
		else
			echo_date 本插件适用于【koolshare merlin armv7l 384】固件平台，你的固件平台不能安装！！！
			echo_date 退出安装！
			rm -rf /tmp/frpc* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin armv7l 384】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/frpc* >/dev/null 2>&1
		exit 1
	;;
esac

# stop frpc first
enable=`dbus get frpc_enable`
if [ "$enable" == "1" ];then
	killall frpc >/dev/null 2>&1
fi

# 安装插件
cp -rf /tmp/frpc/bin/* /koolshare/bin/
cp -rf /tmp/frpc/scripts/* /koolshare/scripts/
cp -rf /tmp/frpc/webs/* /koolshare/webs/
cp -rf /tmp/frpc/res/* /koolshare/res/
cp -rf /tmp/frpc/uninstall.sh /koolshare/scripts/uninstall_frpc.sh
chmod +x /koolshare/bin/*
chmod +x /koolshare/scripts/frpc*.sh
chmod +x /koolshare/scripts/uninstall_frpc.sh

# 离线安装用
dbus set frpc_version="$(cat $DIR/version)"
dbus set softcenter_module_frpc_version="$(cat $DIR/version)"
dbus set softcenter_module_frpc_install="1"
dbus set softcenter_module_frpc_name="frpc"
dbus set softcenter_module_frpc_title="frpc内网穿透"
dbus set softcenter_module_frpc_description="支持多种协议的内网穿透软件"

# re-enable frpc
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/frpc_config.sh start
fi

# 完成
echo_date "frpc内网穿透插件安装完毕！"
rm -rf /tmp/frpc* >/dev/null 2>&1
exit 0
