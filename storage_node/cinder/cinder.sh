set -e

echo "Start storage_node cinder"

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#export environment variable FACTERLIB
export FACTERLIB="$DIR/../../environment/custom_facts"

#Install packages
puppet apply cinder-package.pp

#Create LVM physical volume and volume group
get=$(cat ../../answer.txt | grep 'disk =' )
disk_temp=`echo $get | cut -d'=' -f2`
disk=$(echo $disk_temp | xargs)

IFS=' ' read -r -a array <<< "$disk"
for element in "${array[@]}"
do
    echo "physical volume and volume group creation on disk : $element"

    if [ $(pvs | grep -o $element) ];then
        echo "physical volume $element is already exist! Skip pvcreate..."
    else
        pvcreate $element
        echo "created physical volume on disk : $element"
    fi
    
    if [ $(vgs | grep -o 'cinder-volumes') ];then
        echo "volume group cinder-volumes is already exist!"
        
        if [ $(pvdisplay $element | grep -o 'cinder-volumes') ];then
            echo "$element is already included on cinder-volumes! Skip vgextend..."
        else
            vgextend cinder-volumes $element
        fi
    else
        vgcreate cinder-volumes $element
        echo "cinder-volumes created! $element is included in cinder-volumes"
    fi
done

 
    

#configuration
puppet apply cinder_conf.pp

#Skip add filter on lvm
#This is because there are some unknown errors when add more than two volumes like /dev/sdb and /dev/sdc.
#Hope someone fix this problem.
#puppet apply lvm_conf.pp

#Finalize installation
systemctl enable openstack-cinder-volume.service target.service
systemctl start openstack-cinder-volume.service target.service

echo "Storage_node cinder completed without error!"
