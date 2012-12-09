#include "donuts.h"

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
    printf("listening on port %d...(pid: %d)\n",NC_PORT,getpid());
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
                    read_header(new_sock,&raw.buf);
                    type_val = ntohl(raw.m.mtype);
                    size_val = ntohl(raw.m.msize);
                    switch (type_val)
                    {
                        default:
                            converge_read(new_sock,raw.buf);
                            printf("msg id: %d, msg size %d, raw msg: %s\n",type_val,type_val,raw.buf);
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
