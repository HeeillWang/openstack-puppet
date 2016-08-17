
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
