#include "donuts.h"

int shmid, semid[3];
void sig_handler(int sig);

int get_random_number(void)
{
    //nrand48 to get random number
    struct timeval randtime;
    gettimeofday(&randtime,(struct timezone *) 0);
    unsigned short xsub1[3];
    xsub1[0] = (ushort)randtime.tv_usec;
    xsub1[1] = (ushort)(randtime.tv_usec >> 16);
    xsub1[2] = (ushort)(getpid());
    return nrand48(xsub1) & 3;
}

int main(int argc, char *argv[])
{
    int in_ptr[NUMFLAVORS];
    int serial[NUMFLAVORS];
    int i,j,k;
    struct donut_ring *shared_ring;
    
    //producer inital serial counter and in-pointers
    for (i =0;i< NUMFLAVORS; i++) 
    {
        in_ptr[i] = 0;
        serial[i] =0;
    }

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

    //shared memory
    if ((shmid = shmget(MEMKEY, sizeof (struct donut_ring), IPC_CREAT | 0600)) == -1)
    {
        perror("shared get failed: ");
        exit(1);
    }
    if ((shared_ring = shmat(shmid,NULL,0)) == (void *) -1)
    {
        perror("shared attach failed: ");
        sig_handler(-1);
    }
    
    //shemaphores
    for (i = 0; i<NUMSEMIDS; i++)
    {
        if ((semid[i] = semget(SEMKEY+i, NUMFLAVORS, IPC_CREAT | 0600)) == -1)
        {
            perror("semaphore allocation failed: ");
            sig_handler(-1);
        }
    }
    
    printf("rand number:%d\n",get_random_number());
    
    //initilze semaphores
    if (semsetall(semid[PROD],NUMFLAVORS,NUMSLOTS) == -1)
    {
        perror("semsetall failed: ");
        sig_handler(-1);
    }
    if (semsetall(semid[CONSUMER], NUMFLAVORS, 0) == -1)
    {
        perror("semsetall failed: ");
        sig_handler(-1);
    }
    if (semsetall(semid[OUTPTR],NUMFLAVORS, 1) == -1)
    {
        perror("semsetall failed: ");
        sig_handler(-1);
    }
    printf("semid: %d %d %d\n",semid[0],semid[1],semid[2]);
  
    while(1)
    {
        j = get_random_number();
        p(semid[PROD],j); //lock
        shared_ring->flavor[j][in_ptr[j]] = serial[j];
        printf("Donut:%d\t Serial Number:%d\n",j,shared_ring->flavor[j][in_ptr[j]]);
        in_ptr[j] = (in_ptr[j] + 1) % NUMSLOTS;
        serial[j]++;
        v(semid[CONSUMER],j);
    }
    return 0;
}

void sig_handler(int sig)
{
    int i,j,k;
    printf("In signal hanlder with signal # %d\n", sig);
    if (shmctl(shmid,IPC_RMID, 0) == -1)
    {
        perror("handler failed shm RMID: ");
    }
    for (i = 0; i < NUMSEMIDS; i++)
    {
        if (semctl(semid[i],0,IPC_RMID) == -1)
        {
            perror("handler failed sem RMID: ");
        }
    }
    exit(5);
}

        
