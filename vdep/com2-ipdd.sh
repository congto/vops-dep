#!/bin/bash -ex

source config.cfg

# sudo timedatectl set-timezone  Asia/Ho_Chi_Minh
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
# gateway $GATEWAY_IP
# dns-nameservers 8.8.8.8

# NIC DATA VM
auto em3
iface em3 inet static
address $COM2_DATA_VM_IP
netmask $NETMASK_ADD_VM

# INTERNET TAM
auto em2
iface em2 inet static
address 123.31.10.3
netmask 255.255.255.0
gateway 123.31.10.1
dns-nameservers 8.8.8.8
EOF

#sleep 5

init 6
#

