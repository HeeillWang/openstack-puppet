set -e
echo "Start controller_node nova"

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

#Create database
rootpass=$(cat $DIR/../../answer.txt | grep MYSQL_ROOTPASS)
novapass=$(cat $DIR/../../answer.txt | grep NOVA_DBPASS)

if [ $(mysql -u root -p"${rootpass:17}" mysql -e "SHOW DATABASES" | grep nova) ];then
    echo "database 'nova' is already exists. skip database creation..."
else
    mysql -u root -p"${rootpass:17}" mysql -e "CREATE DATABASE nova" 
fi

mysql -u root -p"${rootpass:17}" mysql -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '${novapass:14}'"
mysql -u root -p"${rootpass:17}" mysql -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '${novapass:14}'"

#Create Nova service, user, role and endpoints
source /root/admin-openrc.sh
authpass=$(cat $DIR/../../answer.txt | grep nova_authpass)

if [ $(openstack user list | grep -w -o nova) ];then
    echo "user 'nova' is already exists! skip user creation..."
else
    openstack user create --domain default --password skcc1234 nova
    openstack role add --project service --user nova admin
fi

if [ $(openstack service list | grep -w -o nova) ];then
    echo "service 'nova' is already exists! skip service and endpoint creation..."
else
    openstack service create --name nova --description "OpenStack Compute" compute
    openstack endpoint create --region RegionOne compute public http://controller:8774/v2/%\(tenant_id\)s
    openstack endpoint create --region RegionOne compute internal http://controller:8774/v2/%\(tenant_id\)s
    openstack endpoint create --region RegionOne compute admin http://controller:8774/v2/%\(tenant_id\)s
fi

#install the packages
puppet apply nova-package.pp

#configuring nova.conf
puppet apply nova_conf.pp

#Populate the Compute database
/bin/sh -c "nova-manage db sync" nova

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
