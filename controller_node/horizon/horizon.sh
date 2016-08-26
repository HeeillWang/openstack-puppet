set -e
echo "Start controller_node horizon"

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

# install horizon
for ((i=0;i<COLUMNS;i++));do
        echo -n "-"
done
echo -e "\nInstall horizon"
for ((i=0;i<COLUMNS;i++));do
        echo -n "-"
done

yum install -y openstack-dashboard

puppet apply horizon.pp

echo "Controller_node horizon completed without error"
