set -e

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

temp=$(cat $DIR/answer.txt | grep "number_compute = ")
number_com=${temp:17}

#Stop and diable NetworkManager
systemctl stop NetworkManager
systemctl disable NetworkManager

#set hostname ad 'controller'
hostnamectl set-hostname controller

#make metadata random
openssl rand -hex 10 > /root/metadata_secret.txt

if [ $number_com == 0 ];then
	./puppet-install.sh
	./environment/environment.sh
	./controller_node/controller.sh
	./computenode/compute.sh
	./storage_node/cinder/cinder.sh
else
	./puppet-install.sh
        ./environment/environment.sh
        ./controller_node/controller.sh
        ./storage_node/cinder/cinder.sh
	./remote/remote_installer.sh
fi

#Restart the services for finalization.
systemctl restart httpd
source /root/admin-openrc.sh
echo 'Restart all openstack-service'
openstack-service restart
