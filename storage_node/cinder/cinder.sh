set -e

echo "Start storage_node cinder"

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#export environment variable FACTERLIB
export FACTERLIB="$DIR/../../environment/custom_facts"
facter | grep keystone

#Install packages
puppet apply cinder-package.pp

#Create LVM physical volume and volume group
disk=$(cat ../../answer.txt | grep 'disk =' )

if [ $(pvs | grep -o ${disk:6}) ];then
    echo "physical volume ${disk:6} is already exist! Skip pvcreate..."
else
    echo "create physical volume"
    pvcreate ${disk:6}
fi
 
if [ $(vgs | grep -o 'cinder-volumes') ];then
    echo "volume group cinder-volumes is already exist! Skip vgcreate..."
else
    vgcreate cinder-volumes ${disk:6}
fi
    

#configuration
puppet apply cinder_conf.pp
puppet apply lvm_conf.pp

#Finalize installation
systemctl enable openstack-cinder-volume.service target.service
systemctl start openstack-cinder-volume.service target.service

echo "Storage_node cinder completed without error!"
