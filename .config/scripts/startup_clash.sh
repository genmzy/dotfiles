#!/bin/bash
cd ~/Backup/clash-for-linux-master/

ps axu|grep clash| grep -v grep

clash_count=`ps axu| grep clash | grep -v "startup_clash" | grep -v grep | wc -l`
echo "clash count: "$clash_count

if [ $clash_count -gt 0 ]
then
	/usr/bin/echo "Clash already started."
else
	ALL_PROXY="" all_proxy="" HTTPS_PROXY=""  https_proxy="" HTTP_PROXY="" http_proxy=""  ./start.sh
fi

