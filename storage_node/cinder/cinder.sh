set -e

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

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

#Finalize installation
systemctl enable openstack-cinder-volume.service target.service
systemctl start openstack-cinder-volume.service target.service
