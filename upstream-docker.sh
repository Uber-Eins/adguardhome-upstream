#!/bin/bash
set -e
if [ "$(ps -o comm= $PPID)" == "systemd" ]; then
    SYSTEMD=1
fi

if [[ $SYSTEMD == 1 ]]; then
    echo "Getting fallback dns..."
else
	DATE=`date --rfc-3339 sec`
    echo "$DATE: Getting fallback dns..."
fi
curl -o "/tmp/default.upstream" https://gitexp.aapa.site/https://raw.githubusercontent.com/Uber-Eins/adguardhome-upstream/master/universal.conf > /dev/null 2>&1

if [[ $SYSTEMD == 1 ]]; then
    echo "Getting data updates..."
else
	DATE=`date --rfc-3339 sec`
    echo "$DATE: Getting data updates..."
fi
curl -s https://gitlab.com/fernvenue/chn-domains-list/-/raw/master/CHN.ALL.agh | sed "/#/d" > "/tmp/chinalist.upstream"

if [[ $SYSTEMD == 1 ]]; then
    echo "Processing data format..."
else
	DATE=`date --rfc-3339 sec`
    echo "$DATE: Processing data format..."
fi
cat "/tmp/default.upstream" "/tmp/chinalist.upstream" > /usr/share/adguardhome.upstream
sed -i "s|114.114.114.114|https://dot.pub:443/dns-query https://dns.alidns.com:443/dns-query|g" /usr/share/adguardhome.upstream

if [[ $SYSTEMD == 1 ]]; then
    echo "Cleaning..."
else
	DATE=`date --rfc-3339 sec`
    echo "$DATE: Cleaning..."
fi
rm /tmp/*.upstream
if [[ $SYSTEMD == 1 ]]; then
    echo "Restarting AdGuardHome service..."
else
	DATE=`date --rfc-3339 sec`
    echo "$DATE: Restarting AdGuardHome service..."
fi
docker restart AdguardHome
if [[ $SYSTEMD == 1 ]]; then
    echo "All finished!"
else
	DATE=`date --rfc-3339 sec`
    echo "$DATE: All finished!"
fi
