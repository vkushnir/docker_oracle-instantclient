#!/bin/ash
echo Update /etc/raddb files from /opt/raddb
cp -R /opt/raddb /etc/
radiusd $@

