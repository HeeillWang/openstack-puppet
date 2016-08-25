#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

#Create database
mysql -u root -p"KEYSTONE_DBPASS" mysql -e "CREATE DATABASE nova"
mysql -u root -p"KEYSTONE_DBPASS" mysql -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS'"
mysql -u root -p"KEYSTONE_DBPASS" mysql -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS'"

#Create Nova service, user, role and endpoints
source /root/admin-openrc.sh

openstack user create --domain default --password skcc1234 nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute
openstack endpoint create --region RegionOne compute public http://controller:8774/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2/%\(tenant_id\)s

#install the packages
sudo puppet apply nova-package.pp

#configuring nova.conf
sudo puppet apply nova_conf.pp

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
