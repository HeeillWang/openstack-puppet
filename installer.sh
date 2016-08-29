#set -e

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

temp=$(cat $DIR/answer.txt | grep "number_compute = ")
number_com=${temp:17}
hostnamectl set-hostname controller

#make metadata random
openssl rand -hex 10 > /root/metadata_secret.txt

if [ $number_com = 0 ];then
	./puppet-install.sh
	./environment/environment.sh
	./controller_node/controller.sh
	./computenode/compute.sh
	./storage_node/cinder/cinder.sh
else
	./puppet-install.sh
        date
        ./environment/environment.sh
        date
        ./controller_node/controller.sh
        date
        ./storage_node/cinder/cinder.sh
        date
	./remote/remote_installer.sh
        date
fi
