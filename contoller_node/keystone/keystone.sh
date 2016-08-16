#Create database and an administration token on mysql

mysql -u root mysql -e "CREATE DATABASE keystone"
mysql -u root mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'skcc1234'"
mysql -u root mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'skcc1234'"

openssl rand -hex 10 > /root/rand_hex.txt
