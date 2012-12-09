all: ftp_client ftp_server
	gcc -o ftp_client ftp_client.o ftp_util.o
	gcc -o ftp_server ftp_server.o ftp_util.o
ftp_client: ftp_client.o ftp_util.o
	gcc -o ftp_client ftp_client.o ftp_util.o
ftp_server: ftp_server.o ftp_util.o
	gcc -o ftp_server ftp_server.o ftp_util.o
ftp_client.o: ftp_client.c ftp.h
	gcc -c ftp_client.c
nodec.o: nodec.c donut.h
	gcc -c nodec.c
donut_util.o: donut_util.c donut.h
	gcc -c donut_util.c
clean:
	rm *.o ftp_client ftp_server
