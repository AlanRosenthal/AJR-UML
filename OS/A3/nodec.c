#include "nodec.h"

int shmid;

void child_handler(int signum)
{
    wait(NULL);
}

int main(int argc, char * argv[])
{
    MSG msg;
    MBUF raw;
    int inet_sock,new_sock;
    int type_val, size_val;
    int i,j,k;//counters
    int flavor,node_id,in_ptr,serial,outptr;
    char string_to_send[256];
    socklen_t fromlen;
    struct sockaddr_in inet_telnum;
    struct hostent *heptr, *gethostbyname();
    int wild_card = INADDR_ANY;
    struct sigaction sigstrc;
    sigset_t mask;
    //set up sigaction structure to clean zombies
    sigemptyset(&mask);
    sigstrc.sa_handler = child_handler;
    sigstrc.sa_mask = mask;
    sigstrc.sa_flags = 0;
    sigaction(SIGCHLD, &sigstrc, NULL);    
    
    //allocate a socket to commuocate with
    if ((inet_sock=socket(AF_INET,SOCK_STREAM, 0)) == -1)
    {
        perror("inet_sock allocation failed: ");
        exit(1);
    }
    bcopy(&wild_card,&inet_telnum.sin_addr, sizeof(int));
    inet_telnum.sin_family = AF_INET;
    inet_telnum.sin_port = htons((u_short) NC_PORT);
    if (bind(inet_sock, (struct sockaddr *)&inet_telnum, sizeof(struct sockaddr_in)) == -1)
    {
        perror("inet_sock bind failed: ");
        exit(2);
    }
    listen(inet_sock,5);
    printf("listening...(pid: %d)\n",getpid());
    while (1)
    {
        fromlen = sizeof(struct sockaddr);
        while ((new_sock = accept(inet_sock, (struct sockaddr *) &inet_telnum, &fromlen)) == -1 && errno == EINTR);
        if (new_sock == -1)
        {
            perror("accept failed: ");
            exit(2);
        }
        switch (fork())
        {
            default:
                close(new_sock);
                break;
                
            case -1:
                perror("fork failed: ");
                exit(1);
                
            case 0:
                //shared memory
                if ((shmid = shmget(MEMKEY, sizeof(donut_ring), 0)) == -1)
                {
                    perror("shared get failed: ");
                    exit(1);
                }
                if ((shared_ring = shmat(shmid,NULL,0)) == (void *) -1)
                {
                    perror("shared attach failed: ");
                }
                
                printf("new connection...(pid: %d, parent pid: %d)\n",getpid(),getppid());
                close(inet_sock);
                while(1)
                {
                    read_header(new_sock,&raw.buf);
                    type_val = ntohl(raw.m.mtype);
                    size_val = ntohl(raw.m.msize);
                    switch (type_val)
                    {
                        case PRODUCE:
                            converge_read(new_sock,raw.buf,size_val);
                            sscanf(raw.buf,"%d %d %d",&node_id,&flavor,&serial);
                            if (shared_ring->space_counter[flavor] > 0)
                            {
                                in_ptr = shared_ring->in_ptr[flavor];
                                shared_ring->donuts[flavor].node_id[in_ptr] = node_id;
                                shared_ring->donuts[flavor].serial[in_ptr] = serial;
                                //needs a lock
                                shared_ring->donut_counter[flavor]++;
                                shared_ring->space_counter[flavor]--;
                                //needs an unlock
                                shared_ring->in_ptr[flavor] = (in_ptr + 1) % NUMSLOTS;
                                make_header(&msg, PRODUCEACK, 0);
                                if (write(new_sock,&msg,2*sizeof(int)) == -1)
                                {
                                    perror("new_sock write failed: ");
                                    exit(3);
                                }
                            }
                    printf("\t\tType 0\tType 1\tType 2\tType 3\nDonut Counter\t%d\t%d\t%d\t%d\n",shared_ring->donut_counter[0],shared_ring->donut_counter[1],shared_ring->donut_counter[2],shared_ring->donut_counter[3]);
                            break;
                        case CONSUME:
                            converge_read(new_sock,raw.buf,size_val);
                            sscanf(raw.buf,"%d",&flavor);
                            if (shared_ring->donut_counter[flavor] > 0)
                            {
                                outptr = shared_ring->outptr[flavor];
                                
                                node_id = shared_ring->donuts[flavor].node_id[outptr];
                                serial = shared_ring->donuts[flavor].serial[outptr];
                                //needs a lock
                                shared_ring->donut_counter[flavor]--;
                                shared_ring->space_counter[flavor]++;
                                //needs an unlock
                                shared_ring->outptr[flavor] = (outptr + 1) % NUMSLOTS;
                                sprintf(string_to_send,"%d %d",node_id,serial);
                                strcpy(msg.mbody,string_to_send);
                                make_header(&msg, CONSUMEACK, strlen(string_to_send) + 1);
                                if (write(new_sock,&msg,2*sizeof(int) + strlen(string_to_send) + 1) == -1)
                                {
                                    perror("new_sock write failed: ");
                                    exit(3);
                                }
                            }
                    printf("\t\tType 0\tType 1\tType 2\tType 3\nDonut Counter\t%d\t%d\t%d\t%d\n",shared_ring->donut_counter[0],shared_ring->donut_counter[1],shared_ring->donut_counter[2],shared_ring->donut_counter[3]);
                            break;
                        
                        default:
                            converge_read(new_sock,raw.buf,size_val);
                            printf("msg id: %d\n",type_val);
                            printf("raw msg: %s\n",raw.buf);
                            printf("enter phrase: ");
                            make_header(&msg, 00000, strlen("this is a test") + 1);
                            strcpy(msg.mbody,"this is a test");
                            if (write(new_sock,&msg,2*sizeof(int) + strlen("this is a test") + 1) == -1)
                            {
                                perror("new_sock write failed: ");
                                exit(3);
                            }
                            break;
                    }
                    exit(0);
                }
                break;
        }
    }
}
