set -e

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

#Create database
rootpass=$(cat $DIR/../../answer.txt | grep MYSQL_ROOTPASS)
keystonepass=$(cat $DIR/../../answer.txt | grep "KEYSTONE_DBPASS =")

if [ $(mysql -u root -p"${rootpass:17}" mysql -e "SHOW DATABASES" | grep keystone) ];then
    echo "database 'keystone' is already exists. skip database creation..."
else
    mysql -u root -p"${rootpass:17}" mysql -e "CREATE DATABASE keystone" 
fi

echo "rootpass : ${rootpass:17}"
echo "keystonepass : ${keystonepass:18}"

mysql -u root -p"${rootpass:17}" mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '${keystonepass:18}'"
mysql -u root -p"${rootpass:17}" mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '${keystonepass:18}'"

#Create token
openssl rand -hex 10 > /root/rand_hex.txt


#Install packages
puppet apply keystone-package.pp
#Config keystone.conf
puppet apply keystone_conf.pp
#Populate the Identity service database
echo "dbsync start!"
/bin/sh -c "keystone-manage db_sync" keystone
echo "dbsync completed"
#Config httpd.conf
puppet apply httpd_conf.pp
#Config wsgi-keystone.conf
puppet apply wsgi-keystone_conf.pp

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
if [ $(openstack service list | grep -w -o keystone) ];then
    echo "service 'keystone' is already exists! skip service and endpoint creation..."
else
openstack service create --name keystone --description "OpenStack Identity" identity
openstack endpoint create --region RegionOne identity public http://controller:5000/v2.0
openstack endpoint create --region RegionOne identity internal http://controller:5000/v2.0
openstack endpoint create --region RegionOne identity admin http://controller:35357/v2.0
fi

#Create projects, users, and roles
adminpass=$(cat $DIR/../../answer.txt | grep admin_authpass)

if [ $(openstack project list | grep -w -o admin) ];then
    echo "project 'admin' is already exists! skip project creation..."
else
    openstack project create --domain default --description "Admin Project" admin
fi


if [ $(openstack user list | grep -w -o admin) ];then
    echo "user 'admin' is already exists! skip user creation..."
else
    openstack user create --domain default --password ${adminpass:17} admin
    openstack role create admin
    openstack role add --project admin --user admin admin
fi


if [ $(openstack project list | grep -w -o service) ];then
    echo "project 'service' is already exists! skip project creation..."
else
    openstack project create --domain default --description "Service Project" service
fi

#Unset the temporary environment variables
unset OS_TOKEN OS_URL

#Creating the scripts
puppet apply create_openrc.pp
