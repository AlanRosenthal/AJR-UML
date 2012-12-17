#include "donut.h"

int node_connect(char * IP,int PORT);
void sig_handler(int sig);

void lamport_send_request(MSG * msg,LAMPORT * lamport,int socket_list[]);
void lamport_send_reply(MSG * msg,LAMPORT * lamport,int sock);

int main(int argc, char * argv[])
{
    int i,j,k,sock;//counters
    int node_id = atoi(argv[1]);
    int socket_list[4];
    if (argc != 7)
    {
        printf("./nodec [node_id] [BM IP] [node 0 IP] [node 1 IP] [node 2 IP] [node 3 IP]\n");
        error(1);
    }
    printf("Starting Node Controller %d...\n",node_id,argc);
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
    //set up socket listening
    if ((inet_sock=socket(AF_INET,SOCK_STREAM, 0)) == -1)
    {
        perror("inet_sock allocation failed");
        exit(1);
    }
    bcopy(&wild_card,&inet_telnum.sin_addr, sizeof(int));
    inet_telnum.sin_family = AF_INET;
    inet_telnum.sin_port = htons((u_short) NC_PORT);
    if (bind(inet_sock, (struct sockaddr *)&inet_telnum, sizeof(struct sockaddr_in)) == -1)
    {
        perror("inet_sock bind failed");
        exit(2);
    }
    listen(inet_sock,5);
    //connect to nodes in network
    printf("Connecting to network...\n");
    switch(node_id)
    {
        case 0:
            //accept connection from node 1
            while ((socket_list[0] = accept(inet_sock, (struct sockaddr *) &inet_telnum, &fromlen)) == -1 && errno == EINTR);
            if (socket_list[0] == -1)
            {
                perror("accept failed");
                exit(2);
            }
            //accept connection from node 2
            while ((socket_list[1] = accept(inet_sock, (struct sockaddr *) &inet_telnum, &fromlen)) == -1 && errno == EINTR);
            if (socket_list[1] == -1)
            {
                perror("accept failed");
                exit(2);
            }
            //accept connection from node 3
            while ((socket_list[2] = accept(inet_sock, (struct sockaddr *) &inet_telnum, &fromlen)) == -1 && errno == EINTR);
            if (socket_list[2] == -1)
            {
                perror("accept failed");
                exit(2);
            }
            close(inet_sock);
            //connect to BM
            socket_list[3] = node_connect(argv[2],BM_PORT);
            break;
        case 1:
            //connect to node 0
            socket_list[0] = node_connect(argv[3],NC_PORT);
            //accept connection from node 2
            while ((socket_list[1] = accept(inet_sock, (struct sockaddr *) &inet_telnum, &fromlen)) == -1 && errno == EINTR);
            if (socket_list[1] == -1)
            {
                perror("accept failed");
                exit(2);
            }
            //accept connection from node 3
            while ((socket_list[2] = accept(inet_sock, (struct sockaddr *) &inet_telnum, &fromlen)) == -1 && errno == EINTR);
            if (socket_list[2] == -1)
            {
                perror("accept failed");
                exit(2);
            }
            close(inet_sock);
            //connect to BM
            socket_list[3] = node_connect(argv[2],BM_PORT);
            break;
        case 2:
            //connect to node 0
            socket_list[0] = node_connect(argv[3],NC_PORT);
            //connect to node 1
            socket_list[1] = node_connect(argv[4],NC_PORT);
            //accept connection from node 3
            while ((socket_list[2] = accept(inet_sock, (struct sockaddr *) &inet_telnum, &fromlen)) == -1 && errno == EINTR);
            if (socket_list[2] == -1)
            {
                perror("accept failed");
                exit(2);
            }
            close(inet_sock);
            //connect to BM
            socket_list[3] = node_connect(argv[2],BM_PORT);
            break;
        case 3:
            close(inet_sock);
            //connect to node 0
            socket_list[0] = node_connect(argv[3],NC_PORT);
            //connect to node 1
            socket_list[1] = node_connect(argv[4],NC_PORT);
            //connect to node 2
            socket_list[2] = node_connect(argv[5],NC_PORT);
            //connect to BM
            socket_list[3] = node_connect(argv[2],BM_PORT);
            break;
        default:
            printf("Unknown Node ID: %d\n",node_id);
            exit(4);
            break;
    }
    for (i = 0;i < 4;i++)
    {
        if (fcntl(socket_list[i],F_SETFL,fcntl(socket_list[i],F_GETFL) | O_NONBLOCK))
        {
            perror("fcntl failed");
            exit(1);
        }
    }
    
    printf("Connected!\n");
    //initialize laport's algorithm
    LAMPORT lamport;
    lamport.clock = 0;
    lamport.queue_size = 0;
    lamport.first = -1;
    lamport.node_id = node_id;
    for (i = 0;i<20;i++)
    {
        lamport.request[i].node_id = -1;
        for (j = 0;j<3;j++)
        {
            lamport.request[i].reply[j].node_id = -1;
        }
        
    }
//     for (i = 0;i < 4;i++)
//     {
//         sprintf(msg.mbody,"HELLO_WORLD node_id %d",node_id);
//         send_message(&msg,socket_list[i],MSG_HELLO_WORLD);
//     }
    if (node_id == 0)
        lamport_send_request(&msg,&lamport,socket_list);
    printf("Socket\tID\tMSG\n");
    j = 0;
    for (sock = 0;1;sock = (sock+1)%4)
    {
        if (converge_read(socket_list[sock],raw.buf) == -1)
        {
            continue;
        }
        type_val = ntohl(raw.m.mtype);
        switch(type_val)
        {
            case MSG_LAMPORT_REQUEST:
                lamport_send_reply(&msg,&lamport,socket_list[sock]);
                break;
            case MSG_LAMPORT_REPLY:
                //lamport_send_request(&msg,&lamport,socket_list);
                break;
            default:
                break;
        }
        printf("%d\t%d\t%s\n",sock,type_val,raw.m.mbody);
    }    
}
void lamport_send_request(MSG * msg,LAMPORT * lamport,int socket_list[])
{
    int i;

    sprintf(msg->mbody,"REQUEST node_id %d clock %d",lamport->node_id,lamport->clock);
    for (i = 0;i < 3;i++)
    {
        send_message(msg,socket_list[i],MSG_LAMPORT_REQUEST);
    }
    lamport->clock++;
}
void lamport_send_reply(MSG * msg,LAMPORT * lamport,int sock)
{
    sprintf(msg->mbody,"REPLY node_id %d clock %d",lamport->node_id,lamport->clock);
    send_message(msg,sock,MSG_LAMPORT_REPLY);
    lamport->clock++;
}

int node_connect(char * IP,int PORT)
{
    int inet_sock;
    struct sockaddr_in inet_telnum;
    struct hostent * heptr, * gethostbyname();
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
}
/*
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
}*/

void sig_handler(int sig)
{
    printf("In signal hanlder with signal # %d\n", sig);
    exit(5);
}