#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

public=$(cat $DIR/../../answer.txt | grep -w ip_public)
public_temp=`echo $public | cut -d'=' -f2`
public_ip=$(echo $public_temp | xargs)
echo $public_ip

source /root/admin-openrc.sh

openstack endpoint create --region RegionOne identity public http://$public_ip:5000/v2.0
