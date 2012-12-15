all: nodec buffer_manager
	gcc -o nodec nodec.o donut_util.o
	gcc -o buffer_manager buffer_manager.o donut_util.o

nodec: nodec.o donut_util.o
	gcc -o nodec nodec.o donut_util.o

buffer_manager: buffer_manager.o donut_util.o
	gcc -o buffer_manager buffer_manager.o donut_util.o

nodec.o: nodec.c donut.h
	gcc -c nodec.c

buffer_manager.o: buffer_manager.c donut.h
	gcc -c buffer_manager.c

donut_util.o: donut_util.c donut.h
	gcc -c donut_util.c
clean:
	rm *.o nodec buffer_manager
