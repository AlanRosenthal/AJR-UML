#include <signal.h>
#include <sys/time.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#define NUMFLAVORS      4
#define NUMSLOTS        500
#define NUMPRODUCERS    30
#define NUMCONSUMERS    50
#define NUMDOZENS       200

typedef struct {
   int flavor[NUMFLAVORS][NUMSLOTS];
   int outptr[NUMFLAVORS];
   int in_ptr[NUMFLAVORS];
   int serial[NUMFLAVORS];
   int donut_counter[NUMFLAVORS];
   int space_counter[NUMFLAVORS];
   int num_dozens[NUMCONSUMERS];
} donut_ring;

typedef struct {
   int serial[12];
   int count;
} donuts;

// SIGNAL WAITER, PRODUCER AND CCONSUMER THREAD FUCCTIONS
void * sig_waiter(void * arg);
void sig_handler(int);
void * producer(void * arg);
void * consumer(void * arg);
void * deadlock_detector(void * arg);

//GLOBAL VARIABLES
donut_ring shared_ring;
pthread_mutex_t prod[NUMFLAVORS];
pthread_mutex_t cons[NUMFLAVORS];
pthread_cond_t prod_cond[NUMFLAVORS];
pthread_cond_t cons_cond[NUMFLAVORS];
pthread_t thread_id[NUMCONSUMERS+NUMPRODUCERS];
pthread_t sig_wait_id;
pthread_t deadlock_id;



int main(int argc, char * argv[])
{
   int i,j,k,nsigs;
   int deadlock_val;
   struct timeval randtime, first_time, last_time;
   struct sigaction new_act;
   int arg_array[NUMCONSUMERS + 1];
   sigset_t all_signals;
   int sigs[] = { SIGBUS, SIGSEGV, SIGFPE };
   
   pthread_attr_t thread_attr;
   struct sched_param sched_struct;
   
   printf("\n\n");
   
   //INITIAL TIMESTAMP VALUE FOR PERFORMANCE MEASURE
   gettimeofday(&first_time, (struct timezone *) 0);
   for (i = 0; i < NUMCONSUMERS + 1; i++)
   {
      arg_array[i] = i;
   }
   
   //GENERAL PTHREAD MUTEX AND CONDITION INIT AND GLOBAL INIT
   for (i = 0; i < NUMFLAVORS; i++)
   {
      pthread_mutex_init(&prod[i],NULL);
      pthread_mutex_init(&cons[i],NULL);
      pthread_cond_init(&prod_cond[i],NULL);
      pthread_cond_init(&cons_cond[i],NULL);
      shared_ring.outptr[i] = 0;
      shared_ring.in_ptr[i] = 0;
      shared_ring.serial[i] = 0;
      shared_ring.space_counter[i] = NUMSLOTS;
      shared_ring.donut_counter[i] = 0;
   }
   
   //SETUP FOR MANAGING THE SIGTERM SIGNAL, BLOCK ALL SIGNALS
   sigfillset(&all_signals);
   nsigs = sizeof(sigs) / sizeof(int);
   for (i = 0;i < nsigs; i++)
   {
      sigdelset(&all_signals,sigs[i]);
   }
   sigprocmask(SIG_BLOCK, &all_signals,NULL);
   sigfillset (&all_signals);
   for (i = 0; i < nsigs; i++)
   {
      new_act.sa_handler = sig_handler;
      new_act.sa_mask = all_signals;
      new_act.sa_flags = 0;
      if (sigaction(sigs[i],&new_act,NULL) == -1)
      {
         perror("Unable to set signals: ");
         exit(1);
      }
   }
   
   printf("Signals set up\n");
   
   //CREATE SIGNAL HANDLER THREAD, PRODUCER, CONSUMERS
   if (pthread_create(&sig_wait_id,NULL,sig_waiter,NULL) != 0)
   {
      printf("pthread_create failed: ");
      exit(3);
   }
   pthread_attr_init(&thread_attr);
   pthread_attr_setinheritsched(&thread_attr, PTHREAD_INHERIT_SCHED);
   
   for (i = 0; i < NUMCONSUMERS; i++)
   {
      if (pthread_create(&thread_id[i], &thread_attr, consumer, (void *) &arg_array[i]) != 0)
      {
         printf("Consumer pthread_create failed: ");
         exit (3);
      }
   }
   for (; i < NUMPRODUCERS + NUMCONSUMERS; i++)
   {
      if (pthread_create(&thread_id[i],&thread_attr,producer, NULL) != 0)
      {
         printf("Producer pthread_create failed: ");
         exit(3);
      }
   }
   if (pthread_create(&deadlock_id, &thread_attr, deadlock_detector, (void *) &deadlock_val) != 0)
   {
      printf("DeadLock Detector pthread_create failed: ");
      exit (3);
   }
   printf("Threads created\n");
   
//    for (i = 0; i < NUMCONSUMERS; i++)
//    {
//       pthread_join(thread_id[i],NULL);
//       printf("Consumer %d finished\n",i);
//    }
   pthread_join(deadlock_id,NULL);
   
   gettimeofday(&last_time, (struct timezone *) 0);
   if ((i = last_time.tv_sec - first_time.tv_sec) == 0)
   {
      j = last_time.tv_usec - first_time.tv_usec;
   }
   else
   {
      if (last_time.tv_usec - first_time.tv_usec < 0)
      {
         i--;
         j = 1000000 + (last_time.tv_usec - first_time.tv_usec);
      }
      else
      {
         j = last_time.tv_usec - first_time.tv_usec;
      }
   }
   printf("Elapsed cons time is %d sec and %d usec\n",i,j);
   printf("\nALL CONSUMERS FINISHED, KILLING PROCESS (%d)\n\n",deadlock_val);
   return 0;
}

void * producer(void * arg)
{
   int i,j,k;
   unsigned short xsub[3];
   struct timeval randtime;
   gettimeofday(&randtime, (struct timezone *) 0);
   xsub[0] = (unsigned short) randtime.tv_usec;
   xsub[1] = (unsigned short) (randtime.tv_usec >> 16);
   xsub[2] = (unsigned short) pthread_self();
   while (1)
   {
      
      j = nrand48(xsub) & 3;
      //Get Producer Mutex
      pthread_mutex_lock(&prod[j]);
      //Check Space count
      while (shared_ring.space_counter[j] == 0)
      {
         pthread_cond_wait(&prod_cond[j],&prod[j]);
      }
      //Put Donut in Queue
      int in_ptr = shared_ring.in_ptr[j];
      shared_ring.flavor[j][in_ptr] = shared_ring.serial[j]++;
      //printf("Produced donut:%d with serial:%d\n",j,shared_ring.flavor[j][in_ptr]);
      shared_ring.in_ptr[j] = (in_ptr + 1) % NUMSLOTS;
      shared_ring.space_counter[j]--;
      //unlock producer mutex
      pthread_mutex_unlock(&prod[j]);
      //get consumer mutex
      pthread_mutex_lock(&cons[j]);
      //increase donut counter
      shared_ring.donut_counter[j]++;
      //unlock consumer mutex
      pthread_mutex_unlock(&cons[j]);
      //signal cons_condx_var      
      pthread_cond_signal(&cons_cond[j]);
   }
   return NULL;
}

void * consumer(void * arg)
{
   int i,j,k,m,id;
   donuts donuts[NUMFLAVORS];
   unsigned short xsub[3];
   struct timeval randtime;
   id = * (int *) arg;
   char buffer[50];
   remove(buffer);
   sprintf(buffer,"./OUTPUT/Consumer_%03d.txt",id);
   FILE * pFile = fopen(buffer,"w");
   gettimeofday(&randtime, (struct timezone *) 0);
   xsub[0] = (unsigned short) randtime.tv_usec;
   xsub[1] = (unsigned short) (randtime.tv_usec >> 16);
   xsub[2] = (unsigned short) pthread_self();
   for (i = 0; i < NUMCONSUMERS; i++)
   {
      shared_ring.num_dozens[i] = 0;
   } 
   for (i = 0; i < NUMDOZENS; i++)
   {
      for (m = 0; m < NUMFLAVORS; m++)
      {
         donuts[m].count = 0;
      }
      for (m = 0; m < 12; m++)
      {
         
         j = nrand48(xsub) & 3;
         //get consumer mutex
         pthread_mutex_lock(&cons[j]);
         //check donut count
         while (shared_ring.donut_counter[j] == 0)
         {
            pthread_cond_wait(&cons_cond[j],&cons[j]);
         }
         //take donut from queue
         int outptr = shared_ring.outptr[j];
         donuts[j].serial[donuts[j].count++] = shared_ring.flavor[j][outptr];
         //printf("Consumer %03d, Donut %d, serial %d\n",id,j,shared_ring.flavor[j][outptr]);
         //update outptr
         
         shared_ring.outptr[j] = (outptr + 1) % NUMSLOTS;
         //dec donut count
         shared_ring.donut_counter[j]--;
         //unluick consumer mutex
         pthread_mutex_unlock(&cons[j]);
         //get producer mutex
         pthread_mutex_lock(&prod[j]);
         //increase space counter
         shared_ring.space_counter[j]++;
         //unlock prod mutex
         pthread_mutex_unlock(&prod[j]);
         //signal prod_condx_var
         pthread_cond_signal(&prod_cond[j]);
      }
      shared_ring.num_dozens[id] = i;

      //print out of donut information
      struct timeval tv; 
      struct tm* ptm; 
      char time_string[40]; 
      long useconds; 
      gettimeofday (&tv, NULL); 
      ptm = localtime (&tv.tv_sec); 
      strftime (time_string, sizeof (time_string), "%H:%M:%S", ptm); 
      useconds = tv.tv_usec; 
      fprintf(pFile,"------------------------------------------------------------------------\n");
      fprintf(pFile,"consumer thread #: %03d\ttime: %s.%06ld\t dozen #: %03d\n",id,time_string, useconds,i);
      fprintf(pFile,"\n");
      fprintf(pFile,"plain\tjelly\tcoconut\thoney-dip\n");
      for (k = 0;k<12;k++)
      {
         int rowtest = 0;
         for (j = 0; j< NUMFLAVORS; j++)
         {
            if (donuts[j].count > k)
            {
               fprintf(pFile,"%d\t",donuts[j].serial[k]);
               rowtest++;
            }
            else
            {
               fprintf(pFile,"\t");
            }
         }
         if (rowtest > 0)
         {
            fprintf(pFile,"\n");
         }
      }
      fprintf(pFile,"\n");
      usleep(1000);
   }
   fclose(pFile);
   return NULL;
}
void * deadlock_detector(void * arg)
{
   int i,j,k;
   int num_dozens_old[NUMCONSUMERS];
   int * deadlock_val = (int *) arg;
   for (i = 0;i < NUMCONSUMERS; i++)
   {
      num_dozens_old[i] = shared_ring.num_dozens[i];
   }
   k = 0;
   while (1)
   {
      //if everyone is finished
      j = 1;
      for (i = 0; i < NUMCONSUMERS; i++)
      {
         if (shared_ring.num_dozens[i] == (NUMDOZENS - 1))
         {
            j++;
         }
      }
      if (j == NUMCONSUMERS)
      {
        *deadlock_val = 1;
        return NULL;
      }
      //check to see if dozens, haven't increased yet
      j = 0;
      for (i = 0; i < NUMCONSUMERS; i++)
      {
         //if there has been change
         if (num_dozens_old[i] != shared_ring.num_dozens[i])
         {
            //update num_dozens
            num_dozens_old[i] = shared_ring.num_dozens[i];
            //reset k
            k = 0;
         }
         else
         {
            j++;
         }
      }
      //if all consumers are the same
      if (j == NUMCONSUMERS)
      {
         k++;
      }
      //the same the last 20 times, we are deadlocked
      if (k == 20)
      {
         *deadlock_val = 0;
         return NULL;
      }
      for (i = 0; i < NUMCONSUMERS; i++)
      {
         printf("%03d ",shared_ring.num_dozens[i]);
      }
      printf("(%d)(%d)\n",j,k);
      usleep(100);
   }
}


void * sig_waiter(void * arg)
{
   sigset_t sigterm_signal;
   int signo;
   sigemptyset(&sigterm_signal);
   sigaddset(&sigterm_signal, SIGTERM);
   sigaddset(&sigterm_signal, SIGINT);
   
   if (sigwait(&sigterm_signal, &signo) != 0)
   {
      printf("\n sigwait failed, exiting()\n");
      exit(2);
   }
   printf("process going down on SIGNAL (number %d)\n\n",signo);
   exit(1);
}

void sig_handler (int sig)
{
   pthread_t signaled_thread_id;
   int i,thread_index;
   signaled_thread_id = pthread_self();
   for (i = 0; i < (NUMCONSUMERS + 1); i++)
   {
      if (signaled_thread_id == thread_id[i])
      {
         thread_index = i;
         break;
      }
   }
   printf("\nThread %d took signal $ %d , PROCESS HALT\n",thread_index,sig);
}
