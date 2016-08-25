set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

puppet apply mariadb.pp

#Set mysql root password
mysql -u root mysql -e "update user set password=password('KEYSTONE_DBPASS') where user='root';flush privileges;" || true
