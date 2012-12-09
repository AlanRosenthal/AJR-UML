#include "donut.h"

int main(int argc, char * argv[])
{
    printf("Starting Node Controller Test Program %d...\n",atoi(argv[1]));
    MSG msg;
    MBUF raw;
    int inet_sock;
    int type_val, size_val, local_size;
    int i,j,k;
    int command_id;
    char * string_to_send;
    int PORT = atoi(argv[2]);
    union type_size;
    struct sockaddr_in inet_telnum;
    struct hostent * heptr, * gethostbyname();
    if((inet_sock = socket(AF_INET, SOCK_STREAM, 0)) == -1)
    {
        perror("inet_sock allocation failed: ");
        exit(1);
    }
    if ((heptr = gethostbyname("127.0.0.1")) == NULL)
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
    printf("Enter Command ID: ");
    scanf("%d",&command_id);
    printf("Enter message: ");
    scanf("%s",msg.mbody);
    make_header(&msg, command_id);
    printf("ID\tSize\tMessage\n%d\t%d\t%s\n",ntohl(msg.mtype),ntohl(msg.msize),msg.mbody);
    if (write(inet_sock,&msg,MSG_SIZE) == -1)
    {
        exit(3);
    }
    printf("Message Sent?...\n");
    while(1);
    while(1)
    {
        read_header(inet_sock,&raw.buf);
        type_val = ntohl(raw.m.mtype);
        size_val = ntohl(raw.m.msize);
        switch(type_val)
        {
            default:
                converge_read(inet_sock,raw.buf,size_val);
                printf("ID: %d, Size: %d, MSG: %s",type_val,size_val,raw.buf);
                break;
        }
    }
    printf("closing...\n");
}
