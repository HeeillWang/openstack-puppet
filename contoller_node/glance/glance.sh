set -e

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

# Create database
rootpass=$(cat $DIR/../../answer.txt | grep MYSQL_ROOTPASS)
glancepass=$(cat $DIR/../../answer.txt | grep GLANCE_DBPASS)

if [ $(mysql -u root -p"${rootpass:17}" mysql -e "SHOW DATABASES" | grep glance) ];then
    echo "database 'glance' is already exists. skip database creation..."
else
    mysql -u root -p"${rootpass:17}" mysql -e "CREATE DATABASE glance" 
fi

mysql -u root -p"${rootpass:17}" mysql -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '${glancepass:16}'"
mysql -u root -p"${rootpass:17}" mysql -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '${glancepass:16}'"

# Create uesr, endpoint, service entry
source /root/admin-openrc.sh
authpass=$(cat $DIR/../../answer.txt | grep cinder_authpass)

for((i=0;i<COLUMNS;i++))do
	echo -n '-'
done
echo 'Create Openstack User: glacne...'

if [ $(openstack user list | grep -w -o glance) ];then
    echo "user 'glance' is already exists! skip user creation..."
else
    openstack user create --domain default --password ${authpass:18} glance
    openstack role add --project service --user glance admin
fi

echo 'Create Openstack Service: glance...'

if [ $(openstack service list | grep -w -o cinder) ];then
    echo "service 'cinder' is already exists! skip service and endpoint creation..."
else
    openstack service create --name glance --description "OpenStack Image service" image
    for((i=0;i<COLUMNS;i++))do
            echo -n '-'
    done
    echo 'Create Image Endpoint...'
    openstack endpoint create --region RegionOne image public http://controller:9292
    openstack endpoint create --region RegionOne image internal http://controller:9292
    openstack endpoint create --region RegionOne image admin http://controller:9292


puppet apply glance_package.pp
puppet apply glance_api.pp
puppet apply glance_regi.pp


/bin/sh -c "glance-manage db_sync" glance

#Verify operation
echo "export OS_IMAGE_API_VERSION=2" tee -a /root/admin-openrc.sh
source /root/admin-openrc.sh
sudo yum install -y wget
wget --directory-prefix=/root/ http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
glance image-create --name "cirros" \
  --file /root/cirros-0.3.4-x86_64-disk.img \
  --disk-format qcow2 --container-format bare \
  --visibility public --progress
