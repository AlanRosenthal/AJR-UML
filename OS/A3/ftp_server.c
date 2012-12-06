#include "ftp.h"

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
    int type_val, size_val, read_val;
    int i,j,k;
    int flavor_id,node_id,in_ptr,serial_id;
    char string_to_send[256];
    socklen_t fromlen;
    char * buffer_ptr;
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
    
    //shared memory
    donut_ring * shared_ring;
    if ((shmid = shmget(MEMKEY, sizeof(donut_ring), IPC_CREAT | 0600)) == -1)
    {
        perror("shared get failed: ");
        exit(1);
    }
    if ((shared_ring = shmat(shmid,NULL,0)) == (void *) -1)
    {
        perror("shared attach failed: ");
    }
    
    
    //allocate a socket to commuocate with
    if ((inet_sock=socket(AF_INET,SOCK_STREAM, 0)) == -1)
    {
        perror("inet_sock allocation failed: ");
        exit(1);
    }
    //byte copy the wildcard IP address INADDR_ANY into IP address structe, along with port and family and use the struct to gie yourself a connect address
    bcopy(&wild_card,&inet_telnum.sin_addr, sizeof(int));
    inet_telnum.sin_family = AF_INET;
    inet_telnum.sin_port = htons((u_short) PORT);
    if (bind(inet_sock, (struct sockaddr *)&inet_telnum, sizeof(struct sockaddr_in)) == -1)
    {
        perror("inet_sock bind failed: ");
        exit(2);
    }

    for (i = 0; i < NUMFLAVORS; i++)
    {
        printf("changing ring buffer\n");
        shared_ring->outptr[i] = 0;
        shared_ring->in_ptr[i] = 0;
        shared_ring->donut_counter[i] = 0;
        shared_ring->space_counter[i] = NUMSLOTS;
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
                            converge_read(new_sock, raw.buf,size_val);
                            sscanf(raw.buf,"%d %d %d",&node_id,&flavor_id,&serial_id);
                            if (shared_ring->space_counter[flavor_id] > 0)
                            {
                                in_ptr = shared_ring->in_ptr[flavor_id];
                                shared_ring->donuts[flavor_id].node_id[in_ptr] = node_id;
                                shared_ring->donuts[flavor_id].serial[in_ptr] = serial_id;
                                shared_ring->donut_counter[flavor_id]++;
                                shared_ring->space_counter[flavor_id]--;
                                shared_ring->in_ptr[flavor_id] = (in_ptr + 1) % NUMSLOTS;
                            }
                            printf("\t\tType 0\tType1\tType2\tType3\n");
                            printf("Donut Counter\t%d\t%d\t%d\t%d\n",shared_ring->donut_counter[0],shared_ring->donut_counter[1],shared_ring->donut_counter[2],shared_ring->donut_counter[3]);
                            printf("Space Counter\t%d\t%d\t%d\t%d\n",shared_ring->space_counter[0],shared_ring->space_counter[1],shared_ring->space_counter[2],shared_ring->space_counter[3]);
                            
                            break;
                        case CONSUME:
                            break;
                        
                        
                        default:
                            converge_read(new_sock, buffer_ptr,read_val);
                            printf("msg id: %d\n",type_val);
                            printf("raw msg: %s\n",raw.buf);
                            printf("enter phrase: ");
                            scanf("%s",string_to_send);
                            make_header(&msg, 00000, strlen(string_to_send) + 1);
                            strcpy(msg.mbody,string_to_send);
                            if (write(new_sock,&msg,2*sizeof(int) + strlen(string_to_send) + 1) == -1)
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
