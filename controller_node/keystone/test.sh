
#move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

#Create database
rootpass=$(cat $DIR/../../answer.txt | grep MYSQL_ROOTPASS)
keystonepass=$(cat $DIR/../../answer.txt | grep "KEYSTONE_DBPASS =")

temp=`echo $rootpass | cut -d'=' -f2`
abc=$(echo $temp | xargs)
echo $temp
echo $abc

mysql -u root -p"$abc"
