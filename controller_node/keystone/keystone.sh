set -e

echo "Start controller_node keystone"

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

#Create database
root=$(cat $DIR/../../answer.txt | grep MYSQL_ROOTPASS)
root_temp=`echo $root | cut -d'=' -f2`
rootpass=$(echo $root_temp | xargs)

keystone=$(cat $DIR/../../answer.txt | grep "KEYSTONE_DBPASS =")
keystone_temp=`echo $keystone | cut -d'=' -f2`
keystonepass=$(echo $keystone_temp | xargs)

if [ $(mysql -u root -p"$rootpass" mysql -e "SHOW DATABASES" | grep keystone) ];then
    echo "database 'keystone' is already exists. skip database creation..."
else
    mysql -u root -p"$rootpass" mysql -e "CREATE DATABASE keystone" 
fi

mysql -u root -p"$rootpass" mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$keystonepass'"
mysql -u root -p"$rootpass" mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$keystonepass'"
mysql -u root -p"$rootpass" mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO 'neutron'@'compute' IDENTIFIED BY '$keystonepass'"

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

#Get public ip address from answer.txt
private=$(cat $DIR/../../answer.txt | grep -w ip_private)
private_temp=`echo $private | cut -d'=' -f2`
private_ip=$(echo $private_temp | xargs)


#Create the service entity and API endpoints
if [ $(openstack service list | grep -w -o keystone) ];then
    echo "service 'keystone' is already exists! skip service and endpoint creation..."
else
openstack service create --name keystone --description "OpenStack Identity" identity
openstack endpoint create --region RegionOne identity public http://$private_ip:5000/v2.0
openstack endpoint create --region RegionOne identity internal http://controller:5000/v2.0
openstack endpoint create --region RegionOne identity admin http://controller:35357/v2.0
fi

#Create projects, users, and roles
admin=$(cat $DIR/../../answer.txt | grep admin_authpass)
admin_temp=`echo $admin | cut -d'=' -f2`
adminpass=$(echo $admin_temp | xargs)


if [ $(openstack project list | grep -w -o admin) ];then
    echo "project 'admin' is already exists! skip project creation..."
else
    openstack project create --domain default --description "Admin Project" admin
fi

echo "admin pass : !!$adminpass!!"

if [ $(openstack user list | grep -w -o admin) ];then
    echo "user 'admin' is already exists! skip user creation..."
else
    openstack user create --domain default --password $adminpass admin
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
source /root/admin-openrc.sh
openstack token issue

echo "Controller_node keystone completed without error"
