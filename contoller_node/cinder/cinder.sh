#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="../../environment/custom_facts/"

#Create database
mysql -u root -p"KEYSTONE_DBPASS" mysql -e "CREATE DATABASE cinder"
mysql -u root -p"KEYSTONE_DBPASS" mysql -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY 'CINDER_DBPASS'"
mysql -u root -p"KEYSTONE_DBPASS" mysql -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY 'CINDER_DBPASS'"

#Create user, role, service and endpoints
source /root/admin-openrc.sh
openstack user create --domain default --password skcc1234 cinder
openstack role add --project service --user cinder admin
openstack service create --name cinder \
  --description "OpenStack Block Storage" volume
openstack service create --name cinderv2 \
  --description "OpenStack Block Storage" volumev2
openstack endpoint create --region RegionOne \
  volume public http://controller:8776/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne \
  volume internal http://controller:8776/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne \
  volume admin http://controller:8776/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne \
  volumev2 public http://controller:8776/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne \
  volumev2 internal http://controller:8776/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne \
  volumev2 admin http://controller:8776/v2/%\(tenant_id\)s

#Installing packages
sudo puppet apply cinder-package.pp

#Configuration
sudo puppet apply cinder_conf.pp

#Populate the Block Storage database
/bin/sh -c "cinder-manage db sync" cinder

#Configure Compute to use Block Storage
sudo puppet apply nova_conf.pp

#Finalize installation
systemctl restart openstack-nova-api.service
systemctl enable openstack-cinder-api.service openstack-cinder-scheduler.service
systemctl start openstack-cinder-api.service openstack-cinder-scheduler.service