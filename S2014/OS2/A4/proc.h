/* proc.h - isbadpid */

#include<ucontext.h>

/* process table declarations and defined constants         */

#ifndef NPROC               /* set the number of processes  */
#define NPROC       10      /*  allowed if not already done */
#endif

/* process state constants */

#define PRCURR      '\001'      /* process is currently running */
#define PRFREE      '\002'      /* process slot is free     */
#define PRREADY     '\003'      /* process is on ready queue    */
#define PRRECV      '\004'      /* process waiting for message  */
#define PRSLEEP     '\005'      /* process is sleeping      */
#define PRSUSP      '\006'      /* process is suspended     */
#define PRWAIT      '\007'      /* process is on semaphore queue*/

/* miscellaneous process definitions */

#define PNREGS      9       /* size of saved register area  */
#define PNMLEN      20      /* length of process "name" */
#define NULLPROC    0       /* id of the null process; it   */
                    /*  is always eligible to run   */
#define BADPID      -1      /* used when invalid pid needed */

#define isbadpid(x) (x<=0 || x>=NPROC)

/* process table entry */

struct  pentry  {
    char pstate;            /* process state: PRCURR, etc.  */
    int pprio;          /* process priority     */
    int psem;           /* semaphore if process waiting */
    int pmsg;           /* message sent to this process */
    Bool phasmsg;       /* True iff pmsg is valid   */
    char pname[PNMLEN];     /* process name         */
    ucontext_t posix_ctxt;  /* POSIX context struct     */
};

extern void ctxsw(ucontext_t*, ucontext_t*);
extern  struct  pentry proctab[];
extern  int numproc;        /* currently active processes   */
extern  int nextproc;       /* search point for free slot   */
extern  int currpid;        /* currently executing process  */
