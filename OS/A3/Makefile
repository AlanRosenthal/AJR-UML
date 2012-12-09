all: nodec nodec_test
	gcc -o nodec nodec.o donut_util.o
	gcc -o nodec_test nodec_test.o donut_util.o
nodec: nodec.o donut_util.o
	gcc -o nodec nodec.o donut_util.o
nodec_test: nodec_test.o donut_util.o
	gcc -o nodec_test nodec_test.o donut_util.o
nodec.o: nodec.c donut.h
	gcc -c nodec.c
nodec_test.o: nodec_test.c donut.h
	gcc -c nodec_test.c
donut_util.o: donut_util.c donut.h

	gcc -c donut_util.c
clean:
	rm *.o nodec
