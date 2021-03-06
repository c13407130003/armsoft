#! /bin/sh
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
			rm -rf /tmp/softether* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin armv7l 384】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/softether* >/dev/null 2>&1
		exit 1
	;;
esac

# stop softether first
enable=`dbus get softether_enable`
if [ "$enable" == "1" ];then
	/koolshare/softether/softether.sh stop
fi

# 安装插件
cd /tmp
find /koolshare/init.d/ -name "*SoftEther*"|xargs rm -rf
cp -rf /tmp/softether/softether /koolshare/
cp -rf /tmp/softether/scripts/* /koolshare/scripts/
cp -rf /tmp/softether/webs/* /koolshare/webs/
cp -rf /tmp/softether/res/* /koolshare/res/
rm -rf /tmp/softether* >/dev/null 2>&1
chmod 755 /koolshare/softether/*
chmod 755 /koolshare/scripts/*
ln -sf /koolshare/softether/softether.sh /koolshare/init.d/S98SoftEther.sh
ln -sf /koolshare/softether/softether.sh /koolshare/init.d/N98SoftEther.sh

# 离线安装用
dbus set softether_version="$(cat $DIR/version)"
dbus set softcenter_module_softether_version="$(cat $DIR/version)"
dbus set softcenter_module_softether_description="VPN全家桶, ver 4.29 build 9680"
dbus set softcenter_module_softether_install="1"
dbus set softcenter_module_softether_name="softether"
dbus set softcenter_module_softether_title="SoftEther_VPN_Server"

# re-enable softether
if [ "$softether_enable" == "1" ];then
	/koolshare/softether/softether.sh start
fi

# 完成
echo_date "SoftEther_VPN_Server插件安装完毕！"
rm -rf /tmp/softether* >/dev/null 2>&1
exit 0
