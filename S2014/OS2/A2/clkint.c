#include <sleep.h>
#include <kernel.h>

void clkint(int notsure)
{
    write(1,"*",1);
    
    if (slnempty == TRUE)
    {
        write(1,"&",1);
        //decrement delta key on first process, if it calls 
    }
    if (preempt-- == 0)
    {
        write(1,"^",1);
        //print out queue
        resched();
    }
    
    //TODO
    //page 136
}

