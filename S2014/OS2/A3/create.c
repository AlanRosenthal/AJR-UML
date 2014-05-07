/* create.c - create, newpid */

#include <conf.h>
#include <kernel.h>
#include <proc.h>
#include <mem.h>
#include <io.h>

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
SYSCALL create(int *procaddr,int ssize,int priority,char *name,int nargs,int args)
{
    int pid;            /* stores new process id    */
    struct  pentry  *pptr;      /* pointer to proc. table entry */
    int *saddr;         /* stack address        */
    sigset_t ps;            /* saved processor status   */
    disable(ps);
    ssize = roundew(ssize);
    pid = newpid();
    if ((ssize < MINSTK) || (pid == SYSERR) || (priority < 1))
    {
        restore(ps);
        return(SYSERR);
    }
    if ((int)(saddr = getstk(ssize)) == SYSERR)
    {
        proctab[pid].pstate=PRFREE; //free pid
        restore(ps);
        return(SYSERR);
    }

    numproc++;
    pptr = &proctab[pid];
    pptr->pstate = PRSUSP;
    strcpy(pptr->pname,name);
    pptr->pprio = priority;
    pptr->pbase = (int) saddr;
    pptr->pstklen = ssize;
    pptr->psem = 0;
    pptr->phasmsg = FALSE;
    pptr->plimit = (int)(saddr - ssize + 1);
    pptr->pargs = nargs;
    
    pptr->posix_ctxt = posix_ctxt_init;
    pptr->posix_ctxt.uc_stack.ss_size = ssize;
    pptr->posix_ctxt.uc_stack.ss_sp = (void*)((int) saddr - ssize + 1);
    pptr->posix_ctxt.uc_stack.ss_flags = 0;
    pptr->posix_ctxt.uc_link = &return_ctxt;
    switch (nargs)
    {
        case 0:
            makecontext(&(pptr->posix_ctxt),(void *)procaddr,0);
            break;
        case 1:
            makecontext(&(pptr->posix_ctxt),(void *)procaddr,1,args);
            break;
        case 2:
            makecontext(&(pptr->posix_ctxt),(void *)procaddr,2,args,*(&args+1));
            break;
        case 3:
            makecontext(&(pptr->posix_ctxt),(void *)procaddr,3,args,*(&args+1),*(&args+2));
            break;
    }
    
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

