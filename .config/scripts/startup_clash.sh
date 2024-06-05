#!/bin/bash

cd ~/Backup/clash-for-linux-master/

clash_count=`ps axu|grep clash| grep -v grep | wc -l`

if [ $clash_count -gt 0 ]
then
	/usr/bin/echo "Clash already started."
else
	ALL_PROXY="" https_proxy="" http_proxy="" ./start.sh
fi

