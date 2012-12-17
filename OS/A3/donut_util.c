#include "donut.h"
int converge_read(int socket, char * buffer);
void send_message(MSG * message_ptr,int socket,int type);

void send_message(MSG * message_ptr,int socket,int type)
{
    message_ptr->msize = htonl(MSG_SIZE);
    message_ptr->mtype = htonl(type);
    if (write(socket,message_ptr,MSG_SIZE) == -1)
    {
        printf("Error writing to socket\n");
        perror("write to socket");
        exit(3);
    }
}
int converge_read(int socket, char * buffer)
{
    int num_bytes = MSG_SIZE;
    int j = 0;
    while ((j = read(socket, buffer, num_bytes)) != num_bytes)
    {
        switch(j)
        {
            case -1:
                if(errno == EAGAIN)
                    return -1;
                perror("inet_sock read failed");
                exit(3);
            case 0:
                return -1;
            default:
                num_bytes -= j;
                buffer += j;
                break;
            
        }
    }
    return 0;
}

