#!/bin/bash
set -e

echo "Start controller_node neutron"

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#make metadata random
openssl rand -hex 10 > /root/metadata_secret.txt

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

root=$(cat $DIR/../../answer.txt | grep MYSQL_ROOTPASS)
root_temp=`echo $root | cut -d'=' -f2`
rootpass=$(echo $root_temp | xargs)

neutron=$(cat $DIR/../../answer.txt | grep NEUTRON_DBPASS)
neutron_temp=`echo $neutron | cut -d'=' -f2`
neutornpass=$(echo $neutron_temp | xargs)

# Database Setting
if [ $(mysql -u root -p"$rootpass" mysql -e "SHOW DATABASES" | grep neutron) ];then
    echo "database 'neutron' is already exists. skip database creation..."
else
    mysql -u root -p"$rootpass" mysql -e "CREATE DATABASE neutron"
fi

mysql -u root -p"$rootpass" mysql -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY '$neutron_pass'"
mysql -u root -p"$rootpass" mysql -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY '$neutron_pass'"


source /root/admin-openrc.sh

for((i=0;i<COLUMNS;i++))do
	echo -n '-'
done

auth=$(cat $DIR/../../answer.txt | grep cinder_authpass)
auth_temp=`echo $auth | cut -d'=' -f2`
authpass=$(echo $auth_temp | xargs)

echo 'Create Openstack User: neutron...'
if [ $(openstack user list | grep -w -o neutron) ];then
	echo "user 'neutron' is already exists! skip user creation..."
else
	openstack user create --domain default --password $authpass neutron
	openstack role add --project service --user neutron admin
fi
for((i=0;i<COLUMNS;i++))do
	echo -n '-'
done
echo 'Create Openstack Service: neutron...'

#Get public ip address from answer.txt
private=$(cat $DIR/../../answer.txt | grep -w ip_private)
private_temp=`echo $private | cut -d'=' -f2`
private_ip=$(echo $private_temp | xargs)

if [ $(openstack service list | grep -w -o neutron) ];then
    echo "service 'neutron' is already exists! skip service and endpoint creation..."
else
	openstack service create --name neutron --description "OpenStack Networking" network

	for((i=0;i<COLUMNS;i++))do
		echo -n '-'
	done
	echo 'Create Service Endpoint: neutron...'
	openstack endpoint create --region RegionOne network public http://$private_ip:9696
	openstack endpoint create --region RegionOne network internal http://controller:9696
	openstack endpoint create --region RegionOne network admin http://controller:9696
fi

echo 'OpenVswitch Settings...'
puppet apply ifcfg-br.pp
#ovs-vsctl add-br br-public
#ovs-vsctl add-br br-private

echo 'Set configure files...'
puppet apply neutron_package.pp
puppet apply neutron_conf.pp
puppet apply ml2_agent.pp
puppet apply ovs_agent.pp
puppet apply l3_agent.pp
puppet apply dhcp_agent.pp
puppet apply metadata.pp
puppet apply nova_conf.pp

echo 'Make symbolic link...'
ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini || true

echo 'Populate database...'
/bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

systemctl restart network

systemctl restart openstack-nova-api.service
systemctl enable neutron-server.service neutron-openvswitch-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service neutron-l3-agent.service
systemctl start neutron-server.service neutron-openvswitch-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service neutron-l3-agent.service
systemctl restart neutron-server.service neutron-openvswitch-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service neutron-l3-agent.service

echo "Controller_node neutron completed without error"
