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
# gateway $GATEWAY_IP
# dns-nameservers 8.8.8.8


# PORTAL NETWORK
auto em2
iface em2 inet static
address $CON_EXT_IP
netmask $NETMASK_ADD_VM

# INTERNET TAM
auto em3
iface em3 inet static
address 123.31.10.8
netmask 255.255.255.0
gateway 123.31.10.1
dns-nameservers 8.8.8.8

EOF


echo "Cau hinh hostname cho CONTROLLER NODE"
sleep 3
echo "VDCITC01101" > /etc/hostname
hostname -F /etc/hostname

init 6
#




