set -e

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

#Create database
rootpass=$(cat $DIR/../../answer.txt | grep MYSQL_ROOTPASS)
pass=${rootpass:17}

if [ $(mysql -u root -p"$pass" mysql -e "SHOW DATABASES" | grep cinder) ];then
    echo "cinder is already exits. skip database creation..."
else
    mysql -u root -p"$pass" mysql -e "CREATE DATABASE cinder" 
fi
    mysql -u root -p"$pass" mysql -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY 'CINDER_DBPASS'"
    mysql -u root -p"$pass" mysql -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY 'CINDER_DBPASS'"

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
