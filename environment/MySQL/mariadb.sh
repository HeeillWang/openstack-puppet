set -e
echo "Start install mariadb"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

puppet apply mariadb.pp

#Set mysql root password
root=$(cat $DIR/../../answer.txt | grep MYSQL_ROOTPASS)
root_temp=`echo $root | cut -d'=' -f2`
rootpass=$(echo $root_temp | xargs)

mysql -u root mysql -e "update user set password=password('$rootpass') where user='root';flush privileges;" || true

echo "Mariadb install completed!"
