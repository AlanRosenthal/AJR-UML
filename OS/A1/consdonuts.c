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
    int donuts[NUMFLAVORS][12];
    int counter[NUMFLAVORS];
    
    for (i = 0;i<NUMFLAVORS;i++)
    {
        counter[i] = 0;
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
        for (k = 0;k<12;k++)
        {
            j = get_random_number();
            int donut_outptr;
            p(semid[CONSUMER],j);//take ticket
            p(semid[OUTPTR],j);//lock the outptr
            donut_outptr = shared_ring->outptr[j];
            donuts[j][counter[j]] = shared_ring->flavor[j][donut_outptr];
            shared_ring->outptr[j]=(donut_outptr + 1) % NUMSLOTS;
            v(semid[OUTPTR],j);//unlock the outptr
            counter[j]++;
            v(semid[PROD],j);//allow producer to make another donut in that slot
            printf("Donut: %d\tSerial Number: %d\n",j,donuts[j][counter[j] - 1]);
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
        printf("consumer process PID: %d\ttime: %s.%06ld\t dozen #: %d\n",getpid(),time_string, useconds,i);
        printf("\n");
        printf("plain\tjelly\tcoconut\thoney-dip\n");
        
        //microsleep to give up CPU
        usleep(100);
    }
    return 0;
}