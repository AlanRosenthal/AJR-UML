#include "donut.h"

//int node_accept(int node_id,int node_id_to_connect);
int node_connect(int node_id,int node_id_to_connect);
void sig_handler(int sig);

int test = 0;
int PORT = 4844;

int main(int argc, char * argv[])
{
    printf("Starting Node Controller %d...\n",atoi(argv[1]));
    int i,j,k;//counters
    int node_id = atoi(argv[1]);
    int socket_list[3];
    //Signal catching 
    sigset_t mask_sigs;
    int nsigs;
    struct sigaction new_action;
    int sigs[] = {SIGHUP,SIGINT,SIGQUIT,SIGBUS,SIGTERM,SIGSEGV,SIGFPE};
    nsigs = sizeof(sigs)/sizeof(int);
    sigemptyset(&mask_sigs);
    for (i = 0; i< nsigs ; i++)
    {
        sigaddset(&mask_sigs,sigs[i]);
    }
    for (i = 0; i < nsigs; i++)
    {
        new_action.sa_handler = sig_handler;
        new_action.sa_mask = mask_sigs;
        new_action.sa_flags = 0;
        
        if (sigaction (sigs[i],&new_action,NULL) == -1)
        {
            perror("can't set signals: ");
            exit(1);
        }
    }
    //socket setup
    int inet_sock;
    int new_sock;
    int wild_card = INADDR_ANY;    
    int type_val;
    int size_val;
    struct sockaddr_in inet_telnum;
    struct hostent *heptr, *gethostbyname();
    socklen_t fromlen = sizeof(struct sockaddr);
    MSG msg;
    MBUF raw;
    //allocate a socket to commuocate with
if (node_id == 0){
    if ((inet_sock=socket(AF_INET,SOCK_STREAM, 0)) == -1)
    {
        perror("inet_sock allocation failed");
        exit(1);
    }
    bcopy(&wild_card,&inet_telnum.sin_addr, sizeof(int));
    inet_telnum.sin_family = AF_INET;
    inet_telnum.sin_port = htons((u_short) PORT);
    if (bind(inet_sock, (struct sockaddr *)&inet_telnum, sizeof(struct sockaddr_in)) == -1)
    {
        perror("inet_sock bind failed");
        exit(2);
    }
    listen(inet_sock,5);
    printf("Listening on port %d...(pid: %d)\n",PORT,getpid());
}    
    switch(node_id)
    {
        case 0:
            printf("Node Controller 0 accepting connections!\n");
            while ((socket_list[0] = accept(inet_sock, (struct sockaddr *) &inet_telnum, &fromlen)) == -1 && errno == EINTR);
            if (socket_list[0] == -1)
            {
                perror("accept failed");
                exit(2);
            }
            printf("new_sock: %d inet_sock: %d\n",socket_list[0],inet_sock);
            //close(inet_sock);
            while ((socket_list[1] = accept(inet_sock, (struct sockaddr *) &inet_telnum, &fromlen)) == -1 && errno == EINTR);
            if (socket_list[1] == -1)
            {
                perror("accept failed");
                exit(2);
            }
            printf("new_sock: %d inet_sock: %d\n",socket_list[0],inet_sock);
            //close(inet_sock);
            while ((socket_list[2] = accept(inet_sock, (struct sockaddr *) &inet_telnum, &fromlen)) == -1 && errno == EINTR);
            if (socket_list[2] == -1)
            {
                perror("accept failed");
                exit(2);
            }
            printf("new_sock: %d inet_sock: %d\n",socket_list[0],inet_sock);
            close(inet_sock);
            break;
        case 1:
 //           socket_list[0] = node_accept(1,2);
 //           socket_list[1] = node_accept(1,3);
            socket_list[2] = node_connect(1,0);
            break;
        case 2:
   //         socket_list[0] = node_accept(2,3);
            socket_list[1] = node_connect(2,0);
            socket_list[2] = node_connect(2,1);
            break;
        case 3:
            socket_list[0] = node_connect(3,1);
            socket_list[1] = node_connect(3,3);
            socket_list[2] = node_connect(3,4);
            break;
        default:
            printf("Unknown Node ID: %d\n",node_id);
            exit(4);
            break;
        
    }
    while(1);
}

int node_connect(int node_id,int node_id_to_connect)
{
    MSG msg;
    MBUF raw;
    int inet_sock;
    int type_val, size_val, local_size;
    int command_id;
    union type_size;
    struct sockaddr_in inet_telnum;
    struct hostent * heptr, * gethostbyname();
    char * IP = "127.0.0.1";
    if((inet_sock = socket(AF_INET, SOCK_STREAM, 0)) == -1)
    {
        perror("inet_sock allocation failed");
        exit(1);
    }
    if ((heptr = gethostbyname(IP)) == NULL)
    {
        perror("gethostbyname failed");
        exit(1);
    }
    bcopy(heptr->h_addr, &inet_telnum.sin_addr, heptr->h_length);
    inet_telnum.sin_family = AF_INET;
    inet_telnum.sin_port = htons((u_short)PORT);
    if (connect(inet_sock, (struct sockaddr *)&inet_telnum,sizeof(struct sockaddr_in)) == -1)
    {
        perror("inet_sock connect failed");
        exit(2);
    }
    return inet_sock;
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

void sig_handler(int sig)
{
    printf("In signal hanlder with signal # %d\n", sig);
    exit(5);
}