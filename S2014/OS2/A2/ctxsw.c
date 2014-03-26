#include "signal.h"
#include "kernel.h"
#include "proc.h"





void ctxsw(ucontext_t * old, ucontext_t * new)
{
    //getcontext(old);
    //setcontext(new);    

    swapcontext(old,new);
    
//    getcontext(old);
//    swapcontext(new,old);
    //page 60


}
