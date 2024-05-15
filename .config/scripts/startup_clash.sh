#!/bin/bash
cd /home/waves/Downloads/ClashLinux/

clash_count=`ps axu|grep cfw| grep -v grep | wc -l`

if [ $clash_count -gt 0 ]
then
	/usr/bin/echo "Clash already started."
else
	/usr/bin/nohup ./cfw 2>&1 > cfw.log &
fi

