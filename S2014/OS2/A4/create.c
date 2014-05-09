/* create.c - create, newpid */

#include <conf.h>
#include <kernel.h>
#include <proc.h>
#include <io.h>
#include <stdarg.h>

LOCAL newpid();

/*------------------------------------------------------------------------
 *  create  -  create a process to start running a procedure
 *------------------------------------------------------------------------
 */
//procedure address
//stack size in words
//proccess priority > 0
//name (for debugging)
//number of args
//argments
SYSCALL create(int *procaddr,int ssize,int priority,char *name,int nargs,...)
{
    int pid;            /* stores new process id    */
    struct  pentry  *pptr;      /* pointer to proc. table entry */
    int *saddr;         /* stack address        */
    va_list args;
    sigset_t ps;            /* saved processor status   */
    disable(ps);
    pid = newpid();
    if ((ssize < MINSTK) || (pid == SYSERR) || (priority < 1))
    {
        restore(ps);
        return(SYSERR);
    }
    saddr = malloc(ssize);
    if (saddr == NULL)
    {
        proctab[pid].pstate=PRFREE; //free pid
        restore(ps);
        perror("malloc failed ");
        return(SYSERR);
    }

    numproc++;
    pptr = &proctab[pid];
    pptr->pstate = PRSUSP;
    strcpy(pptr->pname,name);
    pptr->pprio = priority;
    pptr->psem = 0;
    pptr->phasmsg = FALSE;
    
    pptr->posix_ctxt = posix_ctxt_init;
    pptr->posix_ctxt.uc_stack.ss_size = ssize;
    pptr->posix_ctxt.uc_stack.ss_sp = malloc(ssize);
    pptr->posix_ctxt.uc_stack.ss_flags = 0;
    pptr->posix_ctxt.uc_link = &return_ctxt;
    va_start(args,nargs);
    switch (nargs)
    {
        case 0:
            makecontext(&(pptr->posix_ctxt),(void *)procaddr,0);
            break;
        case 1:
        {
            int arg1 = va_arg(args,int);
            makecontext(&(pptr->posix_ctxt),(void *)procaddr,1,arg1);
            break;
        }
        case 2:
        {
            int arg1 = va_arg(args,int);
            int arg2 = va_arg(args,int);
            makecontext(&(pptr->posix_ctxt),(void *)procaddr,2,arg1,arg2);
            break;
        }
        case 3:
        {
            int arg1 = va_arg(args,int);
            int arg2 = va_arg(args,int);
            int arg3 = va_arg(args,int);
            makecontext(&(pptr->posix_ctxt),(void *)procaddr,3,arg1,arg2,arg3);
            break;
        }
    }
    va_end(args);
    restore(ps);
    return(pid);
}

/*------------------------------------------------------------------------
 * newpid  --  obtain a new (free) process id
 *------------------------------------------------------------------------
 */
LOCAL newpid()
{
    int pid;            /* process id to return     */
    int i;

    for (i=0 ; i<NPROC ; i++) { /* check all NPROC slots    */
        if ( (pid=nextproc--) <= 0)
            nextproc = NPROC-1;
        if (proctab[pid].pstate == PRFREE)
            return(pid);
    }
    return(SYSERR);
}

