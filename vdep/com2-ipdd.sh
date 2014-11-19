#!/bin/bash -ex

source config.cfg

echo "Cau hinh hostname cho COMPUTE2 NODE"
sleep 3
echo "VDCITC011102" > /etc/hostname
hostname -F /etc/hostname

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
address $COM2_ADMIN_IP
netmask $NETMASK_ADD
gateway $GATEWAY_IP
dns-nameservers 8.8.8.8

# NIC DATA VM
auto em3
iface em3 inet static
address $COM2_DATA_VM_IP
netmask $NETMASK_ADD_VM

EOF

#sleep 5

init 6
#

