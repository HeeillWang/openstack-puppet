#Create database and an administration token on mysql

mysql -u root mysql -e "CREATE DATABASE keystone"
mysql -u root mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'KEYSTONE_DBPASS'"
mysql -u root mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'KEYSTONE_DBPASS'"

openssl rand -hex 10 > rand_hex.txt


