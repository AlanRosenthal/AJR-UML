#include <conf.h>
#include <kernel.h>
#include <q.h>

//This file combines the following files
//queue.c
//insert.c
//getitem.c
//newqueue.c


/*------------------------------------------------------------------------
 * enqueue  --  insert an item at the tail of a list
 *------------------------------------------------------------------------
 */
//Item to equeue on a list
//Index in q of list tail
int enqueue(int item,int tail)
{
    struct  qent    *tptr;      /* points to tail entry     */
    struct  qent    *mptr;      /* points to item entry     */

    tptr = &q[tail];
    mptr = &q[item];
    mptr->qnext = tail;
    mptr->qprev = tptr->qprev;
    q[tptr->qprev].qnext = item;
    tptr->qprev = item;
    return(item);
}


/*------------------------------------------------------------------------
 *  dequeue  --  remove an item from a list and return it
 *------------------------------------------------------------------------
 */
int dequeue(int item)
{
    struct  qent    *mptr;      /* pointer to q entry for item  */

    mptr = &q[item];
    q[mptr->qprev].qnext = mptr->qnext;
    q[mptr->qnext].qprev = mptr->qprev;
    return(item);
}


/*------------------------------------------------------------------------
 * getfirst  --  remove and return the first process on a list
 *------------------------------------------------------------------------
 */
//q index of head of list
int getfirst(int head)
{
    int proc;       /* first process on the list    */

    if ((proc=q[head].qnext) < NPROC)
        return( dequeue(proc) );
    else
        return(EMPTY);
}


/*------------------------------------------------------------------------
 * getlast  --  remove and return the last process from a list
 *------------------------------------------------------------------------
 */
//q index of tail of list
int getlast(int tail)
{
    int proc;           /* last process on the list */

    if ((proc=q[tail].qprev) < NPROC)
        return( dequeue(proc) );
    else
        return(EMPTY);
}



/*------------------------------------------------------------------------
 * insert.c  --  insert an process into a q list in key order
 *------------------------------------------------------------------------
 */
//process to insert
//q index of head of list
//key to use for this process
int insert(int proc,int head, int key)
{
    int next;           /* runs through list        */
    int prev;

    next = q[head].qnext;
    while (q[next].qkey < key)  /* tail has MAXINT as key   */
        next = q[next].qnext;
    q[proc].qnext = next;
    q[proc].qprev = prev = q[next].qprev;
    q[proc].qkey  = key;
    q[prev].qnext = proc;
    q[next].qprev = proc;
    return(OK);
}


/*------------------------------------------------------------------------
 * newqueue  --  initialize a new list in the q structure
 *------------------------------------------------------------------------
 */
int newqueue(void)
{
    struct  qent    *hptr;      /* address of new list head */
    struct  qent    *tptr;      /* address of new list tail */
    int hindex, tindex;     /* head and tail indexes    */

    hptr = &q[ hindex=nextqueue++ ];/* nextqueue is global variable */
    tptr = &q[ tindex=nextqueue++ ];/*  giving next used q pos. */
    hptr->qnext = tindex;
    hptr->qprev = EMPTY;
    hptr->qkey  = MININT;
    tptr->qnext = EMPTY;
    tptr->qprev = hindex;
    tptr->qkey  = MAXINT;
    return(hindex);
}

