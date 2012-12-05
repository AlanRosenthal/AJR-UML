#include "ftp.h"

int main(int argc, char * argv[])
{
      printf("1");

   MSG msg;
   MBUF raw;
   int inet_sock, local_file;
   int type_val, saize_val,read_val, local_size;
   int i,j,k;
   char * buffer_ptr, * token_ptr, *last_token_ptr;
   char full_file_path_name[256];
   union type_size;
   struct sockaddr_in inet_telnum;
   struct hostent * heptr, * gethostbyname();
   strcpy(full_file_path_name,"123asdf");
   if((inet_sock = socket(AF_INET, SOCK_STREAM, 0)) == -1)
   {
      perror("inet_sock allocation failed: ");
      exit(1);
   }
   
   if ((heptr = gethostbyname(argv[1])) == NULL)
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
   make_header(&msg, RECV, (local_size=strlen(full_file_path_name) +1));
   strcpy(msg.mbody,argv[2]);
   
   if (write(inet_sock,&msg,local_size + (2*sizeof(int))) == -1)
   {
      perror("inet_sock write failed: ");
      exit(3);
   }
   
}