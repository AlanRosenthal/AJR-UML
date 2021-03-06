/* suspend.c - suspend */

#include <conf.h>
#include <kernel.h>
#include <proc.h>

/*------------------------------------------------------------------------
 *  suspend  --  suspend a process, placing it in hibernation
 *------------------------------------------------------------------------
 */
SYSCALL	suspend(int pid) 		/* id of process to suspend     */
{
	struct	pentry	*pptr;		/* pointer to proc. tab. entry	*/
	sigset_t ps;			/* saved processor status	*/
	int	prio;			/* priority returned		*/
	disable(ps);
    
    pptr= &proctab[pid];
	if ((isbadpid(pid)) || (pid==NULLPROC) || (pptr->pstate != PRCURR && pptr->pstate != PRREADY)) {
		restore(ps);
		return(SYSERR);
	}
	if (pptr->pstate == PRREADY) {
		dequeue(pid);
		pptr->pstate = PRSUSP;
	} else {
		pptr->pstate = PRSUSP;
		resched();
	}
	prio = pptr->pprio;
	restore(ps);
	return(prio);
}
