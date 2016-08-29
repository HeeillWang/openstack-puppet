set -e
echo "Start controller_node nova"

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

#Create database
root=$(cat $DIR/../../answer.txt | grep MYSQL_ROOTPASS)
root_temp=`echo $root | cut -d'=' -f2`
rootpass=$(echo $root_temp | xargs)

nova=$(cat $DIR/../../answer.txt | grep NOVA_DBPASS)
nova_temp=`echo $nova | cut -d'=' -f2`
novapass=$(echo $nova_temp | xargs)

if [ $(mysql -u root -p"$rootpass" mysql -e "SHOW DATABASES" | grep nova) ];then
    echo "database 'nova' is already exists. skip database creation..."
else
    mysql -u root -p"$rootpass" mysql -e "CREATE DATABASE nova" 
fi

mysql -u root -p"$rootpass" mysql -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '$novapass'"
mysql -u root -p"$rootpass" mysql -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '$novapass'"

#Create Nova service, user, role and endpoints
source /root/admin-openrc.sh
auth=$(cat $DIR/../../answer.txt | grep cinder_authpass)
auth_temp=`echo $auth | cut -d'=' -f2`
authpass=$(echo $auth_temp | xargs)

#Get public ip address from answer.txt
private=$(cat $DIR/../../answer.txt | grep -w ip_private)
private_temp=`echo $private | cut -d'=' -f2`
private_ip=$(echo $private_temp | xargs)

if [ $(openstack user list | grep -w -o nova) ];then
    echo "user 'nova' is already exists! skip user creation..."
else
    openstack user create --domain default --password $authpass nova
    openstack role add --project service --user nova admin
fi

if [ $(openstack service list | grep -w -o nova) ];then
    echo "service 'nova' is already exists! skip service and endpoint creation..."
else
    openstack service create --name nova --description "OpenStack Compute" compute
    openstack endpoint create --region RegionOne compute public http://$private_ip:8774/v2/%\(tenant_id\)s
    openstack endpoint create --region RegionOne compute internal http://controller:8774/v2/%\(tenant_id\)s
    openstack endpoint create --region RegionOne compute admin http://controller:8774/v2/%\(tenant_id\)s
fi

#install the packages
puppet apply nova-package.pp

#configuring nova.conf
puppet apply nova_conf.pp

#Populate the Compute database
su -s /bin/sh -c "nova-manage db sync" nova

#Start the Compute services
sudo systemctl enable openstack-nova-api.service \
  openstack-nova-cert.service openstack-nova-consoleauth.service \
  openstack-nova-scheduler.service openstack-nova-conductor.service \
  openstack-nova-novncproxy.service

sudo systemctl start openstack-nova-api.service \
  openstack-nova-cert.service openstack-nova-consoleauth.service \
  openstack-nova-scheduler.service openstack-nova-conductor.service \
  openstack-nova-novncproxy.service

echo "Controller_node nova completed without error"
