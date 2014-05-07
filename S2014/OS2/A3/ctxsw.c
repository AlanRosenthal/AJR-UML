#include "signal.h"
#include "kernel.h"
#include "proc.h"

void ctxsw(ucontext_t * old, ucontext_t * new)
{
    swapcontext(old,new);
}

