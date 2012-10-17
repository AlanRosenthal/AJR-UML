#include <signal.h>
#include <sys/time.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#define NUMFLAVORS      4
#define NUMSLOTS        500
#define NUMCONSUMERS    50
#define NUMPRODUCERS    50

typedef struct {
   int flavor[NUMFLAVORS][NUMSLOTS];
   int outptr[NUMFLAVORS];
   int in_ptr[NUMFLAVORS];
   int serial[NUMFLAVORS];
   int donut_counter[NUMFLAVORS];
   int space_counter[NUMFLAVORS];
} donut_ring;

// SIGNAL WAITER, PRODUCER AND CCONSUMER THREAD FUCCTIONS
void * sig_waiter(void * arg);
void sig_handler(int);
void * producer(void * arg);
void * consumer(void * arg);

//GLOBAL VARIABLES
donut_ring shared_ring;

pthread_mutex_t prod[NUMFLAVORS];
pthread_mutex_t cons[NUMFLAVORS];
pthread_cond_t prod_cond[NUMFLAVORS];
pthread_cond_t cons_cond[NUMFLAVORS];
pthread_t thread_id[NUMCONSUMERS+NUMPRODUCERS];
pthread_t sig_wait_id;



int main(int argc, char * argv[])
{
   int i,j,k,nsigs;
   struct timeval randtime, first_time, last_time;
   struct sigaction new_act;
   int arg_array[NUMCONSUMERS + 1];
   sigset_t all_signals;
   int sigs[] = { SIGBUS, SIGSEGV, SIGFPE };
   
   pthread_attr_t thread_attr;
   struct sched_param sched_struct;

   printf("/n/n");
  
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
         printf("pthread_create failed: ");
         exit (3);
      }
   }
   for (; i < NUMPRODUCERS + NUMCONSUMERS; i++)
   {
      if (pthread_create(&thread_id[i],&thread_attr,producer, NULL) != 0)
      {
         printf("pthread_create failed: ");
         exit(3);
      }
   }
   
   printf("Threads created\n");
   
   //TODO: Wait for all consumers to finish
   
   for (i = 0; i < NUMCONSUMERS; i++)
   {
      pthread_join(thread_id[i],NULL);
   }
   
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
   printf("\n\n ALL CONSUMERS FINISHED, KILLING PROCESS\n\n");
   return 0;
}

void * producer(void *arg)
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
      while (shared_ring.space_counter == 0)
      {
         pthread_cond_wait(&prod_cond[j],&prod[j]);
      }
      //Put Donut in Queue
      int in_ptr = shared_ring.in_ptr[j];
      shared_ring.flavor[j][in_ptr] = shared_ring.serial[j]++;
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
   }
   return NULL;
}
