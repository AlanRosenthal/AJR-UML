#include "ftp.h"

int main(int argc, char * argv[])
{
   MSG msg;
   MBUF raw;
   int inet_sock, local_file;
   int type_val, saize_val,read_val, local_size;
   int i,j,k,temp;
   char * buffer_ptr, * token_ptr, *last_token_ptr;
   char string_to_send[256];
   union type_size;
   struct sockaddr_in inet_telnum;
   struct hostent * heptr, * gethostbyname();
   printf("enter phrase: ");
   scanf("%s",string_to_send);
   
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
   
   if ((temp = connect(inet_sock, (struct sockaddr *)&inet_telnum,sizeof(struct sockaddr_in))) == -1)
   {
      perror("inet_sock connect failed: ");
      exit(2);
   }
   printf("%d\n",temp);
   make_header(&msg, RECV, (local_size=strlen(string_to_send) + 1));
   strcpy(msg.mbody,string_to_send);

   printf("mtype %d msize %d body %s\n",ntohl(msg.mtype),ntohl(msg.msize),msg.mbody);
   printf("sending message \"%s\" size: %d\n",msg.mbody,local_size + (2*(int)sizeof(int)));
   
   if ((temp = write(inet_sock,&msg,local_size + (2*sizeof(int)))) == -1)
   {
      perror("inet_sock write failed: ");
      exit(3);
   }
   printf("%d %d\n",temp,close(inet_sock));
   

   printf("closing...\n");
}