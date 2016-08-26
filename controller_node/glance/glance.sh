#set -e

echo "Start conroller_node glance"

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

# Create database
root=$(cat $DIR/../../answer.txt | grep MYSQL_ROOTPASS)
root_temp=`echo $root | cut -d'=' -f2`
rootpass=$(echo $root_temp | xargs)

glance=$(cat $DIR/../../answer.txt | grep GLANCE_DBPASS)
glance_temp=`echo $glance | cut -d'=' -f2`
glancepass=$(echo $glance_temp | xargs)

if [ $(mysql -u root -p"$rootpass" mysql -e "SHOW DATABASES" | grep glance) ];then
    echo "database 'glance' is already exists. skip database creation..."
else
    mysql -u root -p"$rootpass" mysql -e "CREATE DATABASE glance" 
fi

mysql -u root -p"$rootpass" mysql -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$glancepass'"
mysql -u root -p"$rootpass" mysql -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$glancepass'"

# Create uesr, endpoint, service entry
source /root/admin-openrc.sh
auth=$(cat $DIR/../../answer.txt | grep glance_authpass)
auth_temp=`echo $auth | cut -d'=' -f2`
authpass=$(echo $auth_temp | xargs)

for((i=0;i<COLUMNS;i++))do
	echo -n '-'
done
echo 'Create Openstack User: glance...'

if [ $(openstack user list | grep -w -o glance) ];then
    echo "user 'glance' is already exists! skip user creation..."
else
    openstack user create --domain default --password $authpass} glance
    openstack role add --project service --user glance admin
fi

echo 'Create Openstack Service: glance...'

if [ $(openstack service list | grep -w -o glance) ];then
    echo "service 'glance' is already exists! skip service and endpoint creation..."
else
    openstack service create --name glance --description "OpenStack Image service" image
    for((i=0;i<COLUMNS;i++))do
            echo -n '-'
    done
    echo 'Create Image Endpoint...'
    openstack endpoint create --region RegionOne image public http://controller:9292
    openstack endpoint create --region RegionOne image internal http://controller:9292
    openstack endpoint create --region RegionOne image admin http://controller:9292
fi

puppet apply glance_package.pp
puppet apply glance_api.pp
puppet apply glance_regi.pp


/bin/sh -c "glance-manage db_sync" glance
echo "########glance db sync complete#############"
#Verify operation
echo "export OS_IMAGE_API_VERSION=2" tee -a /root/admin-openrc.sh
source /root/admin-openrc.sh

echo "Start verification"
sudo yum install -y wget
if [ $(glance image-list | grep -w -o cirros) ];then
    echo "image 'cirros' is already exists! skip image creation..."
else
    wget --directory-prefix=/root/ http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
    glance image-create --name "cirros" \
      --file /root/cirros-0.3.4-x86_64-disk.img \
      --disk-format qcow2 --container-format bare \
      --visibility public --progress
fi

echo "Conroller_node glance completed without error"
