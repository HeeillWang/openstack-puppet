set -e

echo "Start controller_node cinder"

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

#Create database
root=$(cat $DIR/../../answer.txt | grep MYSQL_ROOTPASS)
root_temp=`echo $root | cut -d'=' -f2`
rootpass=$(echo $root_temp | xargs)

cinder=$(cat $DIR/../../answer.txt | grep CINDER_DBPASS)
cinder_temp=`echo $cinder | cut -d'=' -f2`
cinderpass=$(echo $cinder_temp | xargs)

if [ $(mysql -u root -p"$rootpass" mysql -e "SHOW DATABASES" | grep cinder) ];then
    echo "database 'cinder' is already exists. skip database creation..."
else
    mysql -u root -p"$rootpass" mysql -e "CREATE DATABASE cinder" 
fi

mysql -u root -p"$rootpass" mysql -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY '$cinderpass'"
mysql -u root -p"$rootpass" mysql -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY '$cinderpass'"


#Create user, role, service and endpoints
source /root/admin-openrc.sh
auth=$(cat $DIR/../../answer.txt | grep cinder_authpass)
auth_temp=`echo $auth | cut -d'=' -f2`
authpass=$(echo $auth_temp | xargs)

if [ $(openstack user list | grep -w -o cinder) ];then
    echo "user 'cinder' is already exists! skip user creation..."
else
    openstack user create --domain default --password $authpass cinder
    openstack role add --project service --user cinder admin
fi

#Get public ip address from answer.txt
public=$(cat $DIR/../../answer.txt | grep -w ip_public)
public_temp=`echo $public | cut -d'=' -f2`
public_ip=$(echo $public_temp | xargs)


if [ $(openstack service list | grep -w -o cinder) ];then
    echo "service 'cinder' is already exists! skip service and endpoint creation..."
else
    openstack service create --name cinder \
      --description "OpenStack Block Storage" volume
    openstack endpoint create --region RegionOne \
      volume public http://$public_ip:8776/v1/%\(tenant_id\)s
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


echo "Conroller_node cinder completed without error"
