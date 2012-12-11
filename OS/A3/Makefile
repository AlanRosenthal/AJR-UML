all: nodec nodec_test
	gcc -o nodec nodec.o donut_util.o
nodec: nodec.o donut_util.o
	gcc -o nodec nodec.o donut_util.o
nodec.o: nodec.c donut.h
	gcc -c nodec.c
donut_util.o: donut_util.c donut.h
	gcc -c donut_util.c
clean:
	rm *.o nodec
