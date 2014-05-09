/* initialize.c - nulluser, sysinit */

#include <conf.h>
#include <kernel.h>
#include <proc.h>
#include <sem.h>
#include <sleep.h>
#include <tty.h>
#include <q.h>
#include <io.h>
//#include <disk.h>
//#include <network.h>

extern void xmain();            /* address of user's main prog  */
extern void end_game(void);
extern int userret(void);
/* Declarations of major kernel variables */


LOCAL sysinit();

struct  pentry  proctab[NPROC]; /* process table            */
int nextproc;       /* next process slot to use in create   */
struct  sentry  semaph[NSEM];   /* semaphore table          */
int nextsem;        /* next semaphore slot to use in screate*/
struct  qent    q[NQENT];   /* q table (see queue.c)        */
int nextqueue;      /* next slot in q structure to use  */
#ifdef  NDEVS
struct  intmap  intmap[NDEVS];  /* interrupt dispatch table     */
#endif
#ifdef  Ntty
struct  tty     tty[Ntty];  /* SLU buffers and mode control     */
#endif

/* active system status */

int numproc;        /* number of live user processes    */
int currpid;        /* id of currently running process  */
int reboot = 0;     /* non-zero after first boot        */

int rdyhead,rdytail;    /* head/tail of ready list (q indexes)  */

ucontext_t posix_ctxt_init, end_game_ctxt, return_ctxt;


/************************************************************************/
/***                NOTE:                     ***/
/***                                      ***/
/***   This is where the system begins after the C environment has    ***/
/***   been established.  Interrupts are initially DISABLED, and      ***/
/***   must eventually be enabled explicitly.  This routine turns     ***/
/***   itself into the null process after initialization.  Because    ***/
/***   the null process must always remain ready to run, it cannot    ***/
/***   execute code that might cause it to be suspended, wait for a   ***/
/***   semaphore, or put to sleep, or exit.  In particular, it must   ***/
/***   not do I/O unless it uses kprintf for polled output.           ***/
/***                                      ***/
/************************************************************************/

/*------------------------------------------------------------------------
 *  nulluser  -- initialize system and become the null process (id==0)
 *------------------------------------------------------------------------
 */
int main(int argc,char * argv[])                /* babysit CPU when no one home */
{
    int userpid;
    sigset_t ps;
    write(1,"STARTING XINU...\n",17);

    if (getcontext(&posix_ctxt_init) == -1)
    {
        perror("getcontext failed in initalize.c ");
        exit(5);
    }

    sysinit(); // initialize all of Xinu 

    //set up the edge of the world
    end_game_ctxt = posix_ctxt_init;
    end_game_ctxt.uc_stack.ss_sp = malloc(MINSTK);
    end_game_ctxt.uc_stack.ss_size = MINSTK;
    end_game_ctxt.uc_stack.ss_flags = 0;
    if (end_game_ctxt.uc_stack.ss_sp == NULL)
    {
        perror("malloc failed ");
        return(SYSERR);
    }
    makecontext(&end_game_ctxt, end_game, 0);


//    enable();           /* enable interrupts */

    /* create a process to execute the user's main program */
    //userpid = create(xmain,INITSTK,INITPRIO,"xmain",INITARGC,1);
    setcontext(&(proctab[NULLPROC].posix_ctxt));

    //unreachable
    while (TRUE) {          /* run forever without actually */
        pause();        /*  executing instructions  */
    }
    return;             /* unreachable          */
}

/*------------------------------------------------------------------------
 *  sysinit  --  initialize all Xinu data structures and devices
 *------------------------------------------------------------------------
 */
sigset_t full_block;
sigset_t full_unblock;


LOCAL sysinit(void)
{
    int i;
    struct  pentry  *pptr;
    struct  sentry  *sptr;

    write(1,"INITIALIZING SYSTEM...\n",23);
    //setup full block and full unblock
    sigemptyset(&full_unblock);
    sigfillset(&full_block);    

    numproc  = 0;           /* initialize system variables */
    nextproc = NPROC-1;
    nextsem  = NSEM-1;
    nextqueue= NPROC;       /* q[0..NPROC-1] are processes */

    for (i=0 ; i<NPROC ; i++)   /* initialize process table */
        proctab[i].pstate = PRFREE;

    pptr = &proctab[NULLPROC];  /* initialize null process entry */
    pptr->pstate = PRCURR;
    pptr->pprio = 0;
    strcpy(pptr->pname, "Null Proc");
    pptr->paddr = (void*) xmain;
    pptr->phasmsg = FALSE;
    
    pptr->posix_ctxt = posix_ctxt_init;
    pptr->posix_ctxt.uc_stack.ss_sp = malloc(NULLSTK);
    pptr->posix_ctxt.uc_stack.ss_size = NULLSTK;
    pptr->posix_ctxt.uc_stack.ss_flags = 0;
    pptr->posix_ctxt.uc_link = &end_game_ctxt;
    if (pptr->posix_ctxt.uc_stack.ss_sp == NULL)
    {
        perror("malloc failed ");
        return(SYSERR);
    }
    makecontext(&(pptr->posix_ctxt),xmain,0);
    currpid = NULLPROC;
    for (i=0 ; i<NSEM ; i++) {  /* initialize semaphores */
        (sptr = &semaph[i])->sstate = SFREE;
        sptr->sqtail = 1 + (sptr->sqhead = newqueue());
    }

    rdytail = 1 + (rdyhead=newqueue());/* initialize ready list */

    return_ctxt = posix_ctxt_init;
    return_ctxt.uc_stack.ss_sp = malloc(MINSTK);
    return_ctxt.uc_stack.ss_size = MINSTK;
    return_ctxt.uc_stack.ss_flags = 0;
    if (return_ctxt.uc_stack.ss_sp == NULL)
    {
        perror("malloc failed ");
        return(SYSERR);
    }
    makecontext(&return_ctxt,(void*) userret, 0);

    clkinit();          /* initialize r.t.clock */
    return(OK);
}
