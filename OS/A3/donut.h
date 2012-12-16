#ifndef _node_c_h_
#define _node_c_

#include <sys/shm.h>
#include <sys/types.h>
#include <string.h>
#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <fcntl.h>
#include <signal.h>
#include <errno.h>
#include <stdlib.h>

#define MSG_BODY 248
#define MSG_SIZE (MSG_BODY+8)

#define NC_PORT 4844
#define BM_PORT 4845

#define LAMPORT_REQUEST 100
#define LAMPORT_REPLY   101
#define LAMPORT_RELEASE 102

typedef struct {
    int mtype;
    int msize;
    char mbody[MSG_BODY];
} MSG;

typedef union {
    MSG m;
    char buf[MSG_SIZE];
} MBUF;

typedef struct {
    int message_type;
    int clock;
    int node_id;
    int previous;
    int next;
} LAMPORT_MESSAGE;

typedef struct {
    int clock;
    int queue_lenght;
    LAMPORT_MESSAGE messages[20];
    char first;
} LAMPORT;

#define NUMFLAVORS 4
#define NUMSLOTS 20
#define NUMPRODUCERS 10

#define MEMKEY (key_t)617595240


typedef struct {
    int node_id[NUMSLOTS];
    int serial[NUMSLOTS];
} donuts_t;


typedef struct {
    donuts_t donuts[NUMFLAVORS];
    int outptr[NUMFLAVORS];
    int in_ptr[NUMFLAVORS];
    int donut_counter[NUMFLAVORS];
    int space_counter[NUMFLAVORS];
} donut_ring;


extern int errno;

#endif
