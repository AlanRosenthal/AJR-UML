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
    struct donut_ring *shared_ring;
    int i,j,k;
    int donuts[NUMFLAVORS][12];
    int counter[NUMFLAVORS];
    
    
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
    if ((shmid = shmget(MEMKEY, sizeof (struct donut_ring), 0)) == -1)
    {
        perror("shared get failed: ");
        exit(1);
    }
    if ((shared_ring = shmat(shmid,NULL,0)) == (void *) -1)
    {
        perror("shared attach failed: ");
    }
    //shemaphores
    for (i = 0; i<NUMSEMIDS; i++)
    {
        if ((semid[i] = semget(SEMKEY+i, NUMFLAVORS, 0)) == -1)
        {
            perror("semaphore allocation failed: ");
        }
    }
    
    for (i = 0;i < 10; i++)
    {
        for (k = 0;k<NUMFLAVORS;k++)
        {
            counter[k] = 0;
        }
        for (k = 0;k<12;k++)
        {
            j = get_random_number();
            int donut_outptr;
            //take ticket
            if (p(semid[CONSUMER],j) == -1)
            {
                sig_handler(-1);
            }
            //lock the outptr
            if (p(semid[OUTPTR],j) == -1)
            {
                sig_handler(-1);
            }
            donuts[j][counter[j]] = shared_ring->flavor[j][shared_ring->outptr[j]];
            shared_ring->outptr[j]=(shared_ring->outptr[j] + 1) % NUMSLOTS;
            //unlock the outptr
            if (v(semid[OUTPTR],j) == -1)
            {
                sig_handler(-1);
            }
            //allow producer to make another donut in that slot
            if (v(semid[PROD],j) == -1)
            {
                sig_handler(-1);
            }
            printf("Donut: %d\tSerial Number: %d\n",j,donuts[j][counter[j]]);
            counter[j]++;
        }
        
        //print out of donut information
        struct timeval tv; 
        struct tm* ptm; 
        char time_string[40]; 
        long useconds; 
        gettimeofday (&tv, NULL); 
        ptm = localtime (&tv.tv_sec); 
        strftime (time_string, sizeof (time_string), "%H:%M:%S", ptm); 
        useconds = tv.tv_usec; 
        printf("------------------------------------------------------------------------\n");
        printf("consumer process PID: %d\ttime: %s.%06ld\t dozen #: %d\n",getpid(),time_string, useconds,i);
        printf("\n");
        printf("plain\tjelly\tcoconut\thoney-dip\n");
        for (k = 0;k<12;k++)
        {
            int rowtest = 0;
            for (j = 0; j< NUMFLAVORS; j++)
            {
                if (counter[j] > k)
                {
                    printf("%d\t",donuts[j][k]);
                    rowtest++;
                }
                else
                {
                    printf("\t");
                }
            }
            if (rowtest > 0)
            {
                printf("\n");
            }
        }
        printf("\r");
        printf("------------------------------------------------------------------------\n");
        printf("\n");
        
        //microsleep to give up CPU
        usleep(100);
    }
    return 0;
}

void sig_handler(int sig)
{
    int i,j,k;
    printf("In signal hanlder with signal # %d\n", sig);
    exit(5);
}