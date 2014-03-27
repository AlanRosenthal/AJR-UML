/* create.c - create, newpid */

#include <conf.h>
#include <kernel.h>
#include <proc.h>
#include <mem.h>
#include <io.h>
#include <string.h>

LOCAL newpid();

/*------------------------------------------------------------------------
 *  create  -  create a process to start running a procedure
 *------------------------------------------------------------------------
 */
SYSCALL create( int *procaddr,  /* procedure address            */ 
        int ssize,  /* stack size in words          */ 
        int priority,   /* process priority > 0         */
        char *name,     /* name (for debugging)         */
        int nargs,  /* number of args that follow   */
        int args)   /* arguments (treated like an   */
                /* array in the code)           */
{
    int pid;            /* stores new process id    */
    struct  pentry  *pptr;      /* pointer to proc. table entry */
    int i;
    int *a;         /* points to list of args   */
    int *saddr;         /* stack address        */
    sigset_t ps;            /* saved processor status   */
    int INITRET();
    disable(ps);
    ssize = roundew(ssize);
    pid = newpid();
    saddr = getstk(ssize);
//    if ( ssize < MINSTK || (((int)(saddr=getstk(ssize))) == SYSERR ) || (pid=newpid()) == SYSERR || isodd(procaddr) || priority < 1 ) {
    if ((ssize < MINSTK) || ((int) saddr  == SYSERR) || (pid == SYSERR) || (isodd(procaddr)) || (priority < 1)) {
//    if ((ssize < MINSTK) || ((int) saddr  == SYSERR) || (pid == SYSERR) || (priority < 1)) {
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
    pptr->posix_ctxt.uc_stack.ss_sp = saddr;
    pptr->posix_ctxt.uc_stack.ss_flags = 0;
    pptr->posix_ctxt.uc_link = &end_game_ctxt;
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
//  for (i=0 ; i<PNREGS ; i++)
//      pptr->pregs[i]=INITREG;
//  pptr->pregs[PC] = pptr->paddr = (int)procaddr;
//  pptr->pregs[PS] = INITPS;

//  a = (&args) + (nargs-1);    /* point to last argument   */
//  for ( ; nargs > 0 ; nargs--)    /* machine dependent; copy args */
//      *saddr-- = *a--;    /* onto created process' stack  */
//  *saddr = (int)INITRET;      /* push on return address   */
//  pptr->pregs[SP] = (int)saddr;

    restore(ps);
    return(pid);
}

/*------------------------------------------------------------------------
 * newpid  --  obtain a new (free) process id
 *------------------------------------------------------------------------
 */
LOCAL   newpid()
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
