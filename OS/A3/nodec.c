#include "donut.h"

void node_accept(int node_id);
void node_connect(int node_id,int node_to_connect);

int test = 0;
int PORT = 4844;
void child_handler(int signum)
{
    wait(NULL);
}
int main(int argc, char * argv[])
{
    printf("Starting Node Controller %d...\n",atoi(argv[1]));
    int i,j,k;//counters
    int node_id = atoi(argv[1]);
    int node_id_to_connect;
    struct sigaction sigstrc;
    sigset_t mask;
    //set up sigaction structure to clean zombies
    sigemptyset(&mask);
    sigstrc.sa_handler = child_handler;
    sigstrc.sa_mask = mask;
    sigstrc.sa_flags = 0;
    sigaction(SIGCHLD, &sigstrc, NULL);
    
    switch(node_id)
    {
        case 1:
            switch(fork())
            {
                default:
                    break;
                case -1:
                    perror("fork failed: ");
                    exit(1);
                case 0:
                    printf("Accepting connects...\n");
                    node_accept(1);
                    break;
            }
            break;
        case 2:
            switch(fork())
            {
                default:
                    break;
                case -1:
                    perror("fork failed: ");
                    exit(1);
                case 0:
                    printf("Accepting connects...\n");
                    node_accept(2);
                    break;
            }
            switch(fork())
            {
                default:
                    break;
                case -1:
                    perror("fork failed: ");
                    exit(1);
                case 0:
                    printf("Connecting...\n");
                    node_conecct(1);
                    break;
            }
            break;
        case 3:
            switch(fork())
            {
                default:
                    break;
                case -1:
                    perror("fork failed: ");
                    exit(1);
                case 0:
                    printf("Accepting connects...\n");
                    node_accept(3);
                    break;
            }
            switch(fork())
            {
                default:
                    break;
                case -1:
                    perror("fork failed: ");
                    exit(1);
                case 0:
                    printf("Connecting...\n");
                    node_conecct(1);
                    break;
            }
            switch(fork())
            {
                default:
                    break;
                case -1:
                    perror("fork failed: ");
                    exit(1);
                case 0:
                    printf("Connecting...\n");
                    node_conecct(2);
                    break;
            }
            break;
        case 4:
            switch(fork())
            {
                default:
                    break;
                case -1:
                    perror("fork failed: ");
                    exit(1);
                case 0:
                    printf("Connecting...\n");
                    node_conecct(1);
                    break;
            }
            switch(fork())
            {
                default:
                    break;
                case -1:
                    perror("fork failed: ");
                    exit(1);
                case 0:
                    printf("Connecting...\n");
                    node_conecct(2);
                    break;
            }
            switch(fork())
            {
                default:
                    break;
                case -1:
                    perror("fork failed: ");
                    exit(1);
                case 0:
                    printf("Connecting...\n");
                    node_conecct(3);
                    break;
            }
            break;
        default:
            printf("Unknown Node ID: %d\n",node_id);
            exit(4);
            break;
        
    }
    while(1);
}
void node_accept(int node_id)
{
    int inet_sock;
    int new_sock;
    int wild_card = INADDR_ANY;    
    int type_val;
    int size_val;
    socklen_t fromlen;
    struct sockaddr_in inet_telnum;
    struct hostent *heptr, *gethostbyname();
    MSG msg;
    MBUF raw;
   
    //allocate a socket to commuocate with
    if ((inet_sock=socket(AF_INET,SOCK_STREAM, 0)) == -1)
    {
        perror("inet_sock allocation failed: ");
        exit(1);
    }
    bcopy(&wild_card,&inet_telnum.sin_addr, sizeof(int));
    inet_telnum.sin_family = AF_INET;
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
        printf("PID\tID\tSize\tMessage\n");
        switch (fork())
        {
            default://parent
                close(new_sock);
                break;
                
            case -1://error in parent
                perror("fork failed: ");
                exit(1);
                
            case 0://child
                close(inet_sock);
                while(1)
                {
                    converge_read(new_sock,raw.buf);
                    type_val = ntohl(raw.m.mtype);
                    size_val = ntohl(raw.m.msize);
                    switch (type_val)
                    {
                        default:
                            printf("%d\t%d\t%d\t%s\n",getpid(),type_val,size_val,raw.m.mbody);
                            sprintf(msg.mbody,"Node Controller Test %d",test++);
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
void node_connect(int node_id,int node_to_connect)
{
    MSG msg;
    MBUF raw;
    int inet_sock;
    int type_val, size_val, local_size;
    int command_id;
    union type_size;
    struct sockaddr_in inet_telnum;
    struct hostent * heptr, * gethostbyname();
    if((inet_sock = socket(AF_INET, SOCK_STREAM, 0)) == -1)
    {
        perror("inet_sock allocation failed: ");
        exit(1);
    }
    if ((heptr = gethostbyname(IP)) == NULL)
    {
        perror("gethostbyname failed: ");
        exit(1);
    }
    bcopy(heptr->h_addr, &inet_telnum.sin_addr, heptr->h_length);
    inet_telnum.sin_family = AF_INET;
    inet_telnum.sin_port = htons((u_short)PORT);
    if (connect(inet_sock, (struct sockaddr *)&inet_telnum,sizeof(struct sockaddr_in)) == -1)
    {
        perror("inet_sock connect failed: ");
        exit(2);
    }
    while(1)
    {
        printf("Enter Command ID: ");
        scanf("%d",&command_id);
        printf("Enter message: ");
        scanf("%s",msg.mbody);
        make_header(&msg, command_id);
        if (write(inet_sock,&msg,MSG_SIZE) == -1)
        {
            exit(3);
        }
        printf("Message Sent...\n");
        converge_read(inet_sock,raw.buf);
        //read_header(inet_sock,&raw.buf);
        type_val = ntohl(raw.m.mtype);
        size_val = ntohl(raw.m.msize);
        switch(type_val)
        {
            default:
                printf("ID: %d, Size: %d, MSG: %s\n",type_val,size_val,raw.m.mbody);
                break;
        }
    }
    printf("closing...\n");
}

