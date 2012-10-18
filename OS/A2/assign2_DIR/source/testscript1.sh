#! /bin/sh
echo "" > results.txt
echo "" > results.csv
numdozens=100
while test $numdozens -lt 301
do
numslots=100
while test $numslots -lt 1501
do
numflavors=4
numproducers=30
numconsumers=50
echo "#define NUMFLAVORS $numflavors" > my_th_donuts.h
echo "#define NUMSLOTS $numslots" >> my_th_donuts.h
echo "#define NUMPRODUCERS $numproducers" >> my_th_donuts.h
echo "#define NUMCONSUMERS $numconsumers" >> my_th_donuts.h
echo "#define NUMDOZENS $numdozens" >> my_th_donuts.h
make clean
make
echo "" > output.txt 
loop=0
while test $loop -ne 100
do
echo "Working on Loop $loop for NumSlots: $numslots for NumDozens: $numdozens"
./my_th_donuts >> output.txt
loop=`expr $loop + 1`
done
failed=$(grep -c "Result: 0" output.txt)
passed=$(grep -c "Result: 1" output.txt)
echo "NumSlots: $numslots Failed: $failed Passed: $passed for NumDozens: $numdozens"
echo "NumSlots: $numslots Failed: $failed Passed: $passed for NumDozens: $numdozens" >> results.txt
echo "$numdozens,$numslots,$failed" >> results.csv
numslots=`expr $numslots + 25`
done
numdozens=`expr $numdozens + 50`
done