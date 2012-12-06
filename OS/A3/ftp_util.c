#include "ftp.h"

void make_header(MSG * message_ptr, int type, int size)
{
    message_ptr->msize = htonl(size);
    message_ptr->mtype = htonl(type);
}

void read_header(int socket, char * buffer)
{
    int i,temp;
    for (i = 0; i < (2*sizeof(int)); i++)
    {
        if ((temp = read(socket,buffer+i, 1)) != 1)
        {
            printf("Read val: %d\n",temp);
            perror("read_type_size failed: ");
            exit(3);
        }
    }
}

void converge_read(int socket, char * buffer, int num_bytes)
{
    int j;
    while ((j = read(socket, buffer, num_bytes)) != num_bytes)
    {
        switch(j)
        {
            default:
                num_bytes -= j;
                buffer += j;
                break;
            case -1:
                perror("inet_sock read failed: ");
                exit(3);
            case 0:
                printf("unexpected eof in inet_sock\n");
                exit(4);
        }
    }
}
