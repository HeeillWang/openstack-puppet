set -e

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

#Create database
rootpass=$(cat $DIR/../../answer.txt | grep MYSQL_ROOTPASS)
cinderpass=$(cat $DIR/../../answer.txt | grep CINDER_DBPASS)

if [ $(mysql -u root -p"${rootpass:17}" mysql -e "SHOW DATABASES" | grep cinder) ];then
    echo "database 'cinder' is already exists. skip database creation..."
else
    mysql -u root -p"${rootpass:17}" mysql -e "CREATE DATABASE cinder" 
fi

mysql -u root -p"${rootpass:17}" mysql -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY '${cinderpass:16}'"
mysql -u root -p"${rootpass:17}" mysql -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY '${cinderpass:16}'"


#Create user, role, service and endpoints
source /root/admin-openrc.sh
authpass=$(cat $DIR/../../answer.txt | grep cinder_authpass)

if [ $(openstack user list | grep -w -o cinder) ];then
    echo "user 'cinder' is already exists! skip user creation..."
else
    openstack user create --domain default --password ${authpass:18} cinder
    openstack role add --project service --user cinder admin
fi


if [ $(openstack service list | grep -w -o cinder) ];then
    echo "service 'cinder' is already exists! skip service and endpoint creation..."
else
    openstack service create --name cinder \
      --description "OpenStack Block Storage" volume
    openstack endpoint create --region RegionOne \
      volume public http://controller:8776/v1/%\(tenant_id\)s
    openstack endpoint create --region RegionOne \
      volume internal http://controller:8776/v1/%\(tenant_id\)s
    openstack endpoint create --region RegionOne \
      volume admin http://controller:8776/v1/%\(tenant_id\)s
fi


if [ $(openstack service list | grep -w -o cinderv2) ];then
    echo "service 'cinderv2' is already exists! skip service and endpoint creation..."
else
    openstack service create --name cinderv2 \
      --description "OpenStack Block Storage" volumev2
    openstack endpoint create --region RegionOne \
      volumev2 public http://controller:8776/v2/%\(tenant_id\)s
    openstack endpoint create --region RegionOne \
      volumev2 internal http://controller:8776/v2/%\(tenant_id\)s
    openstack endpoint create --region RegionOne \
      volumev2 admin http://controller:8776/v2/%\(tenant_id\)s
fi


#Installing packages
puppet apply cinder-package.pp

#Configuration
puppet apply cinder_conf.pp

#Populate the Block Storage database
/bin/sh -c "cinder-manage db sync" cinder

#Configure Compute to use Block Storage
puppet apply nova_conf.pp

#Finalize installation
systemctl restart openstack-nova-api.service
systemctl enable openstack-cinder-api.service openstack-cinder-scheduler.service
systemctl start openstack-cinder-api.service openstack-cinder-scheduler.service
