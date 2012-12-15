hostname >> hostfile.txt

count=0 
cat hostfile.txt | while read LINE
do
    let count++
    echo "$count $LINE"
done