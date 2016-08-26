DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
export FACTERLIB="$DIR/../custom_facts"

echo "Start install chrony"
puppet apply ntp.pp
echo "Chrony install completed!"

