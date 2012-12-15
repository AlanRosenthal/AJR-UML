hostname=$1
echo "Node Controller $1"
hosts=""

while read LINE
do
    hosts="$hosts $LINE"
done < hostfile.txt

./nodec $1 $hosts
