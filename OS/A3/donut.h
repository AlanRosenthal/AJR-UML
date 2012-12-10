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

#define NODE1_IP "127.0.0.1"
#define NODE2_IP "127.0.0.1"
#define NODE3_IP "127.0.0.1"
#define NODE4_IP "127.0.0.1"

#define PRODUCE 1
#define PRODUCEACK 101
#define PRODUCENACK 201
#define CONSUME 2
#define CONSUMEACK 102
#define CONSUMENACK 202
#define NC_TEST 300

typedef struct {
    int mtype;
    int msize;
    char mbody[MSG_BODY];
} MSG;

typedef union {
    MSG m;
    char buf[MSG_SIZE];
} MBUF;

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
