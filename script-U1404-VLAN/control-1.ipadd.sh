#!/bin/bash -ex
source config.cfg

ifaces=/etc/network/interfaces
test -f $ifaces.orig || cp $ifaces $ifaces.orig
rm $ifaces
touch $ifaces
cat << EOF >> $ifaces
#Dat IP cho $HOST_NAME node

# LOOPBACK NET 
auto lo
iface lo inet loopback

# MGNT NETWORK
auto em1
iface em1 inet static
address $CON_MGNT_IP
netmask $NETMASK_ADD
gateway $GATEWAY_IP
dns-nameservers 8.8.8.8


# VLANs NETWORK
auto em2
iface em2 inet manual
up ifconfig \$IFACE 0.0.0.0 up
up ip link set \$IFACE promisc on
down ifconfig \$IFACE 0.0.0.0 down

# VLAN DATA NETWORK
auto em3
iface em3 inet manual
up ifconfig \$IFACE 0.0.0.0 up
up ip link set \$IFACE promisc on
down ifconfig \$IFACE 0.0.0.0 down

EOF

echo "Cau hinh hostname cho $HOST_NAME NODE"
sleep 3
echo "controller1" > /etc/hostname
hostname -F /etc/hostname

echo "##### Khoi dong lai may #####"
sleep 5
init 6
#
