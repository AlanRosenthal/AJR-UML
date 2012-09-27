#include "donuts.h"

int shmid, semid[3];

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
        for (j = 0;j<12;j++)
        {
            k = get_random_number();
            
        }
        struct tm * timeinfo;
        localtime (&timeinfo);
        char buffer[80];
        strftime(buffer,80,"%Y-%m-%d %H:%M:%S",&timeinfo);
        printf("consumer process PID: %d\ttime: %s\t\t dozen #: %d\n",getpid(),buffer,i);
        usleep(100);
    }
    return 0;
}