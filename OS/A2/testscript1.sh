#! /bin/sh
numslots=25
echo "" > results.txt
while test $numslots -lt 1001
do
numflavors=4
numproducers=30
numconsumers=50
numdozens=200
echo "#define NUMFLAVORS $numflavors" > my_th_donuts.h
echo "#define NUMSLOTS $numslots" >> my_th_donuts.h
echo "#define NUMPRODUCERS $numproducers" >> my_th_donuts.h
echo "#define NUMCONSUMERS $numconsumers" >> my_th_donuts.h
echo "#define NUMDOZENS $numdozens" >> my_th_donuts.h
make clean
make
echo "" > output.txt 
loopcount=100
loop=0
while test $loop -ne $loopcount
do
echo "Working on Loop $loop for NumSlots: $numslots"
./my_th_donuts >> output.txt
loop=`expr $loop + 1`
done
failed=$(grep -c "Result: 0" output.txt)
passed=$(grep -c "Result: 1" output.txt)
echo "NumSlots: $numslots Failed: $failed Passed: $passed"
echo "NumSlots: $numslots Failed: $failed Passed: $passed" >> results.txt
numslots=`expr $numslots + 25`
done