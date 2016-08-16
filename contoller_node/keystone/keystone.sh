#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Create database and an administration token on mysql
mysql -u root mysql -e "update user set password=password('KEYSTONE_DBPASS') where user='root';flush privileges;"
mysql -u root -p"KEYSTONE_DBPASS" mysql -e "CREATE DATABASE keystone"
mysql -u root -p"KEYSTONE_DBPASS" mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'KEYSTONE_DBPASS'"
mysql -u root -p"KEYSTONE_DBPASS" mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'KEYSTONE_DBPASS'"

openssl rand -hex 10 > /root/rand_hex.txt


#Install packages
sudo puppet apply keystone-package.pp
#Config keystone.conf
sudo puppet apply keystone_conf.pp
#Populate the Identity service database
/bin/sh -c "keystone-manage db_sync" keystone
#Config httpd.conf
sudo puppet apply httpd_conf.pp
#Config wsgi-keystone.conf
sudo puppet apply wsgi-keystone_conf.pp

sudo systemctl enable httpd.service
sudo systemctl start httpd.service 

#For prevent internal server error(http:500)
sudo chown -R keystone:keystone /etc/keystone/
sudo chown -R keystone:keystone /var/log/keystone/
sudo chown -R keystone:keystone /usr/bin/keystone-wsgi-public
sudo service httpd restart

#Configuring environmnet variable
token=$(cat /root/rand_hex.txt)
export OS_TOKEN=$token
export OS_URL="http://controller:35357/v3"
export OS_IDENTITY_API_VERSION="3"


#Create the service entity and API endpoints
openstack service create --name keystone --description "OpenStack Identity" identity
openstack endpoint create --region RegionOne identity public http://controller:5000/v2.0
openstack endpoint create --region RegionOne identity internal http://controller:5000/v2.0
openstack endpoint create --region RegionOne identity admin http://controller:35357/v2.0

#Create projects, users, and roles
openstack project create --domain default --description "Admin Project" admin
openstack user create --domain default --password skcc1234 admin
openstack role create admin
openstack role add --project admin --user admin admin

openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password demo
openstack role create user
openstack role add --project demo --user demo user

#Unset the temporary environment variables
unset OS_TOKEN OS_URL

#Creating the scripts
sudo puppet apply create_openrc.pp
