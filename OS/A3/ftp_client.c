#include "ftp.h"

int main(int argc, char * argv[])
{
    MSG msg;
    MBUF raw;
    int inet_sock, local_file;
    int type_val, size_val,read_val, local_size;
    int i,j,k,temp;
    char * buffer_ptr, * token_ptr, *last_token_ptr;
    int command_id;
    char string_to_send[MSG_SIZE];
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
    printf("enter command_id: ");
    scanf("%d",&command_id);
    printf("enter phrase: ");
    scanf("%s",string_to_send);
    make_header(&msg, command_id, (local_size=strlen(string_to_send) + 1));
    strcpy(msg.mbody,string_to_send);
    
    printf("mtype %d msize %d body %s\n",ntohl(msg.mtype),ntohl(msg.msize),msg.mbody);
    printf("sending message \"%s\" size: %d\n",msg.mbody,local_size + (2*(int)sizeof(int)));
    
    if (write(inet_sock,&msg,local_size + (2*sizeof(int))) == -1)
    {
        perror("inet_sock write failed: ");
        exit(3);
    }
    while(1)
    {
        read_header(inet_sock,&raw.buf);
        type_val = ntohl(raw.m.mtype);
        size_val = ntohl(raw.m.msize);
        read_val = size_val;
        buffer_ptr = raw.buf;
        switch(type_val)
        {
            default:
                converge_read(inet_sock,buffer_ptr,read_val);
                printf("msg id: %d\n",type_val);
                printf("raw size: %d\n",size_val);
                printf("raw msg: %s\n",raw.buf);
                break;
        }
    }
    printf("closing...\n");
}