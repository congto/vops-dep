## Huong dan

# Tai cac goi
```sh
apt-get update

apt-get install git -y
	
git clone https://github.com/congto/vops-dep
	
mv /root/vops-dep/vdep vdep

cd /root/vdep
	
chmod +x *.sh
```

#### Thực thi script tạo password random
```sh
bash pass-random.sh
```

#### Thiet lap IP cho CONTROLLER
```sh
 bash control-1.ipadd.sh
 ```
 
 #### Cai dat cac goi chuan bi
 ```sh
 cd vdep/
bash control-2.prepare.sh
```

#### Cai dat DB
```sh
bash control-3.create-db.sh
```

#### Cai dat keystone
```sh
bash control-4.keystone.sh
```

#### Tao user, endpoint
```sh
bash control-5-creatusetenant.sh
```

#### Tao bien moi truong
```sh
source admin-openrc.sh
 ```
 #### Cai GLANCE
 ```sh
 bash control-6.glance.sh
```
