#include <sleep.h>
#include <kernel.h>
#include <q.h>
void printallqueue(int queue)
{
    char tmp[100];
    printf("\n");
    while (queue != -1)
    {
        write(1,tmp,sprintf(tmp,"id: %d\tkey: %d\tqnext: %d\tqprev: %d\n",queue,q[queue].qkey,q[queue].qnext,q[queue].qprev));
        queue = q[queue].qnext;
    }
}
void clkint(int signal)
{
    if (slnempty == TRUE)
    {
        if (q[q[clockq].qnext].qkey-- == 0)
        {
            wakeup();            
        }
    }
    if (--preempt <= 0)
    {
        preempt = 0; //don't let preempt get to zero
        resched();
    }
}
