clear
if [ $1 == "BM" ]; then
    rm hostfile.txt
fi
hostname >> hostfile.txt
lines=0
echo "Waiting for nodes..."
while [ $lines -ne 5 ]
do
    lines=$(grep -cE ? hostfile.txt)
done
echo "All nodes present, press enter to connect!"
read
if [ $1 == "BM" ]; then
    echo "Launching Buffer Mananger..."
    ./buffer_manager
else
    echo "Launching Node Controller $1..."
    hosts=""
    while read LINE
    do
        hosts="$hosts $LINE"
    done < hostfile.txt
    ./nodec $1 $hosts
fi