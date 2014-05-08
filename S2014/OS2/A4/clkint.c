#include <sleep.h>
#include <kernel.h>
#include <q.h>

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
