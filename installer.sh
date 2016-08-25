set -e

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

temp=$(cat $DIR/answer.txt | grep "number_compute = ")
number_com=${temp:17}

if [ $number_com = 0 ];then
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
