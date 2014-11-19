#!/bin/bash -ex
source config.cfg
sleep 3

echo -e "\e[34m ##### Tao endpoint #####\e[0m"
keystone user-create --name=ceilometer --pass=$CEILOMETER_PASS --email=ceilometer@vdc.com.vn
keystone user-role-add --user=ceilometer --tenant=service --role=admin

keystone service-create --name=ceilometer --type=metering \
--description="Telemetry"
keystone endpoint-create \
--region=$REGIONNAME \
--service-id=$(keystone service-list | awk '/ metering / {print $2}') \
--publicurl=http://$CON_ADMIN_IP:8777 \
--internalurl=http://$CON_ADMIN_IP:8777 \
--adminurl=http://$CON_ADMIN_IP:8777

sleep 7
echo -e "\e[34m ##### Cai cac goi cho  Telemetry #####\e[0m"
apt-get -y install ceilometer-api ceilometer-collector ceilometer-agent-central \
ceilometer-agent-notification ceilometer-alarm-evaluator ceilometer-alarm-notifier python-ceilometerclient

echo -e "\e[34m ##### Cai cac goi cho mongodb-server #####\e[0m"  
apt-get -y install mongodb-server
service mongodb stop
# rm /var/lib/mongodb/journal/prealloc.*
service mongodb start

sed -i "s/127.0.0.1/$CON_ADMIN_IP/g" /etc/mongodb.conf

service mongodb restart

sleep 7
mongo --host $CON_ADMIN_IP --eval '
db = db.getSiblingDB("ceilometer");
db.addUser({user: "ceilometer",
            pwd: "$CEILOMETER_DBPASS",
            roles: [ "readWrite", "dbAdmin" ]})'
			

####
echo "Cau hinh cho ceilometer"
sleep 7
fileceilo=/etc/ceilometer/ceilometer.conf
test -f $fileceilo.orig || cp $fileceilo $fileceilo.orig
rm $fileceilo
touch $fileceilo
cat << EOF > $fileceilo
[DEFAULT]
log_dir = /var/log/ceilometer
sqlite_db=ceilometer.sqlite
# rpc_backend = rabbit
rabbit_host = $CON_ADMIN_IP
rabbit_password = $RABBIT_PASS

auth_strategy = keystone


[alarm]
[api]
[collector]
[database]
backend=sqlalchemy
connection = mongodb://ceilometer:$CEILOMETER_DBPASS@$CON_ADMIN_IP:27017/ceilometer

[dispatcher_file]
[event]

[keystone_authtoken]
auth_host = $CON_ADMIN_IP
auth_port = 35357
auth_protocol = http
auth_uri = http://$CON_ADMIN_IP:5000
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


############
service ceilometer-agent-central restart
service ceilometer-agent-notification restart
service ceilometer-api restart
service ceilometer-collector restart
service ceilometer-alarm-evaluator restart
service ceilometer-alarm-notifier restart

###################
echo -e "\e[34m ######### Hoan thanh viec cai dat CEILOMETER ##########\e[0m"

echo -e "\e[92m Chuyen sang thu hien tren NETWORK NODE va COMPUTE NODE \e[0m"
echo -e "\e[92m Sau do quay lai $CON_ADMIN_IP de cai Hoziron\e[0m "
