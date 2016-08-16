#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Create database and an administration token on mysql
#mysql -u root mysql -e "update user set password=password('KEYSTONE_DBPASS') where user='root';flush privileges;"
#mysql -u root -p"KEYSTONE_DBPASS" mysql -e "CREATE DATABASE keystone"
#mysql -u root -p"KEYSTONE_DBPASS" mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'KEYSTONE_DBPASS'"
#mysql -u root -p"KEYSTONE_DBPASS" mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'KEYSTONE_DBPASS'"

openssl rand -hex 10 > /root/rand_hex.txt


#Install packages
sudo puppet apply keystone-package.pp
#Config keystone.conf
sudo puppet apply keystone_conf.pp
#Populate the Identity service database
/bin/sh -c "keystone-manage db_sync" keystone
#Config httpd.conf
sudo puppet apply httpd_conf.pp
#Config wsgi-keystone.conf
sudo puppet apply wsgi-keystone_conf.pp

sudo systemctl enable httpd.service
sudo systemctl start httpd.service 
