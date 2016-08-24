set -e

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Create LVM physical volume and volume group
disk=$(cat ../../answer.txt | grep 'disk =' )
echo creating LVM pv on : ${disk:6}

#pvcreate $disk
#vgcreate cinder-volumes $disk

#configuration
puppet apply cinder_conf.pp

#Finalize installation
systemctl enable openstack-cinder-volume.service target.service
systemctl start openstack-cinder-volume.service target.service
