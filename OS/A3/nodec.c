#include "donut.h"

//Node 1 Connects to Node 2, 3, 4
//Node 2 Connects to Node 3, 4
//Node 3 Connects to Node 4

//Node 2 Accepts from Node 1
//Node 3 Accepts from Node 1, 2
//Node 4 Accepts from Node 1, 2, 3

void child_handler(int signum)
{
    wait(NULL);
}
int main(int argc, char * argv[])
{
    printf("Starting Node Controller %d...\n",atoi(argv[1]));
    MSG msg;
    MBUF raw;
    int inet_sock,new_sock;
    int type_val, size_val;
    int i,j,k;//counters
    int flavor,node_id,in_ptr,serial,outptr;
    char string_to_send[256];
    int PORT = atoi(argv[2]);
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
    //TODO: change PORT back to NC_PORT (testing on local machine)
    inet_telnum.sin_port = htons((u_short) PORT);
    if (bind(inet_sock, (struct sockaddr *)&inet_telnum, sizeof(struct sockaddr_in)) == -1)
    {
        perror("inet_sock bind failed: ");
        exit(2);
    }
    listen(inet_sock,5);
    printf("Listening on port %d...(pid: %d)\n",PORT,getpid());
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
                printf("new connection...(pid: %d, parent pid: %d)\n",getpid(),getppid());
                close(inet_sock);
                while(1)
                {
                    converge_read(new_sock,raw.buf);
                    type_val = ntohl(raw.m.mtype);
                    size_val = ntohl(raw.m.msize);
                    switch (type_val)
                    {
                        default:
                            printf("msg id: %d, msg size %d, raw msg: %s\n",type_val,size_val,raw.m.mbody);
                            strcpy(msg.mbody,"Node Controller test");
                            make_header(&msg, NC_TEST);
                            if (write(new_sock,&msg,MSG_SIZE) == -1)
		            {
		                perror("new_sock write failed: ");
                                exit(3);
                            }
                            break;
                    }
                }
                break;
        }
    }
}
