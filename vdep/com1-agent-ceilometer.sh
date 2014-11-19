#!/bin/bash -ex

source config.cfg

echo "Cau hinh cho ceilometer"
fileceilo=/etc/ceilometer/ceilometer.conf
test -f $fileceilo.orig || cp $fileceilo $fileceilo.orig
rm $iphost
touch $iphost
cat << EOF >>
[DEFAULT]
sqlite_db=ceilometer.sqlite
rabbit_host = $CON_ADMIN_IP
rabbit_password = $RABBIT_PASS
log_dir = /var/log/ceilometer

[alarm]
[api]
[collector]
[database]
backend=sqlalchemy
connection=sqlite:////var/lib/ceilometer/$sqlite_db
[dispatcher_file]
[event]
[keystone_authtoken]
auth_host = $CON_ADMIN_IP
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = ceilometer
admin_password = $CEILOMETER_PASS

[matchmaker_redis]
[matchmaker_ring]
[notification]

[publisher]
metering_secret = $METERING_SECRET

[publisher_rpc]
[rpc_notifier2]

[service_credentials]
os_auth_url = http://$CON_ADMIN_IP:5000/v2.0
os_username = ceilometer
os_tenant_name = service
os_password = $CEILOMETER_PASS

[ssl]
[vmware]

EOF

sed -i  's/#instance_usage_audit/instance_usage_audit/' /etc/nova/nova.conf
sed -i  's/#instance_usage_audit_period/instance_usage_audit_period/' /etc/nova/nova.conf
sed -i  's/#notify_on_state_change/notify_on_state_change/' /etc/nova/nova.conf
sed -i  's/#notification_driver/notification_driver/' /etc/nova/nova.conf

service nova-compute restart
service ceilometer-agent-compute restart
 
echo "HOan thanh cai dat agent ceilometer tren compute"
