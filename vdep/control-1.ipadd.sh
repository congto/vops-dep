#!/bin/bash -ex
source config.cfg

ifaces=/etc/network/interfaces
test -f $ifaces.orig || cp $ifaces $ifaces.orig
rm $ifaces
touch $ifaces
cat << EOF >> $ifaces
#Dat IP cho Controller node

# LOOPBACK NET 
auto lo
iface lo inet loopback

# ADMIN NETWORK
auto em1
iface em1 inet static
address $CON_ADMIN_IP
netmask $NETMASK_ADD
gateway $GATEWAY_IP
dns-nameservers 8.8.8.8


# PORTAL NETWORK
auto em2
iface em2 inet static
address $CON_EXT_IP
netmask $NETMASK_ADD_VM

EOF


echo "Cau hinh hostname cho CONTROLLER NODE"
sleep 3
echo "VDCITC01101" > /etc/hostname
hostname -F /etc/hostname

init 6
#




