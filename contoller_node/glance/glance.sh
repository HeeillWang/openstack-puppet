# Create database
sudo mysql -u root -p"KEYSTONE_DBPASS" mysql -e "CREATE DATABASE glance;"
sudo mysql -u root -p"KEYSTONE_DBPASS" mysql -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'GLANCE_DBPASS';"
sudo mysql -u root -p"KEYSTONE_DBPASS" mysql -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'controller' IDENTIFIED BY 'GLANCE_DBPASS';"
sudo mysql -u root -p"KEYSTONE_DBPASS" mysql -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'GLANCE_DBPASS';"

# Create uesr, endpoint, service entry
source /root/admin-openrc.sh

for((i=0;i<COLUMNS;i++))do
	echo -n '-'
done
echo 'Create Openstack User: glacne...'
openstack user create --domain default --password skcc1234 glance

for((i=0;i<COLUMNS;i++))do
        echo -n '-'
done
echo 'Add user role: admin...'
openstack role add --project service --user glance admin
for((i=0;i<COLUMNS;i++))do
        echo -n '-'
done
echo 'Create Openstack Service: glance...'
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


su -s /bin/sh -c "glance-manage db_sync" glance

#Verify operation
echo "export OS_IMAGE_API_VERSION=2" tee -a /root/admin-openrc.sh
source /root/admin-openrc.sh
sudo yum install -y wget
wget --directory-prefix=/root/ http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
glance image-create --name "cirros" \
  --file /root/cirros-0.3.4-x86_64-disk.img \
  --disk-format qcow2 --container-format bare \
  --visibility public --progress
