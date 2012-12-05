#include "ftp.h"

static int test_id = 0;

void child_handler (int signum)
{
   wait(NULL);
}

int main (int argc, char * argv[])
{
   printf("Starting FTP Server...\n");
   MSG msg;
   MBUF raw;
   int inet_sock,new_sock,local_file;
   int type_val, size_val, read_val, sleep_interval;
   int i,j,k;
   socklen_t fromlen;
   char * buffer_ptr;
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
   //if theres an arg on the command line use it to test sleep interval
   if (argc == 2)
   {
      sleep_interval = atoi(argv[1]);
   }
   else
   {
      sleep_interval = 1;
   }
   
   //allocate a socket to commuocate with
   if ((inet_sock=socket(AF_INET,SOCK_STREAM, 0)) == -1)
   {
      perror("inet_sock allocation failed: ");
      exit(1);
   }
   //byte copy the wildcard IP address INADDR_ANY into IP address structe, along with port and family and use the struct to gie yourself a connect address
   bcopy(&wild_card,&inet_telnum.sin_addr, sizeof(int));
   inet_telnum.sin_family = AF_INET;
   inet_telnum.sin_port = htons((u_short) PORT);
   if (bind(inet_sock, (struct sockaddr *)&inet_telnum, sizeof(struct sockaddr_in)) == -1)
   {
      perror("inet_sock bind failed: ");
      exit(2);
   }
   
   listen(inet_sock,5);
   printf("listening...(pid: %d)\n",getpid());
   while (1)
   {
      fromlen = sizeof(struct sockaddr);
      while ((new_sock = accept(inet_sock, (struct sockaddr *) &inet_telnum, &fromlen) == -1) && errno == EINTR);
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
            printf("new connection...(pid: %d %d)\n",getpid(),getppid());
            close(inet_sock);
            while(1)
            {
               printf("new sock %d\n",new_sock);
               read_header(new_sock,&raw.buf);
               type_val = ntohl(raw.m.mtype);
               size_val = ntohl(raw.m.msize);
               read_val = size_val;
               buffer_ptr = raw.buf;
               switch (type_val)
               {
                  case RECV:
                     printf("RECV\n");
                     converge_read(new_sock, buffer_ptr,read_val);
                     printf("raw msg: %s\n",raw.buf);
                     break;
                  case TEST:
                     printf("TEST\n");
                     break;
                  default:
                     printf("typeval: %d\n",type_val);
                     break;
               }
               printf("exiting...\n");
               exit(0);
            }
            break;
      }
   }
}
