#! /bin/bash

# yum update
for ((i=0;i<COLUMNS;i++));do
	echo -n "-"
done
echo -e "\nOperating Yum Update"
for ((i=0;i<COLUMNS;i++));do
	echo -n "-"
done
sudo yum -y update

sleep 1

# Repository
for ((i=0;i<COLUMNS;i++));do
	echo -n "-"
done
echo -e "\nRepository Download"
for ((i=0;i<COLUMNS;i++));do
	echo -n "-"
done

sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm

sleep 1

# install puppet
for ((i=0;i<COLUMNS;i++));do
	echo -n "-"
done
echo -e "\nInstall Puppet"
for ((i=0;i<COLUMNS;i++));do
	echo -n "-"
done

sudo yum install -y puppetserver

sudo puppet module install puppetlabs-stdlib

echo "Puppet install completed!"
