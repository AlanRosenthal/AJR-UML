#include <conf.h>
#include <kernel.h>
#include <mem.h>

//This file combines the following files
//freemem.c
//getmem.c
//getstk.c

/*------------------------------------------------------------------------
 *  freemem  --  free a memory block, returning it to memlist
 *------------------------------------------------------------------------
 */
SYSCALL freemem(struct  mblock  *block, unsigned size)
{
    sigset_t ps;
    struct  mblock  *p, *q;
    unsigned top;

    if ((size==0) || ((unsigned)block>(unsigned)maxaddr) || (((unsigned)block)<((unsigned)&end)))
        return(SYSERR);
    size = (unsigned)roundew(size);
    disable(ps);
    for( p=memlist.mnext,q= &memlist ; (char *)p!=NULL && p<block ; q=p,p=p->mnext )
        ;
    if ((top=q->mlen+(unsigned)q)>(unsigned)block && q!= &memlist ||
        (char *)p!=NULL && (size+(unsigned)block) > (unsigned)p) {
        restore(ps);
        return(SYSERR);
    }
    if ( q!= &memlist && top == (unsigned)block )
        q->mlen += size;
    else {
        block->mlen = size;
        block->mnext = p;
        q->mnext = block;
        q = block;
    }
    if ( (unsigned)( q->mlen + (unsigned)q ) == (unsigned)p) {
        q->mlen += p->mlen;
        q->mnext = p->mnext;
    }
    restore(ps);
    return(OK);
}


/*------------------------------------------------------------------------
 * getstk  --  allocate stack memory, returning address of topmost int
 *------------------------------------------------------------------------
 */
SYSCALL *getstk(unsigned  int nbytes)
{
    sigset_t ps;
    struct  mblock  *p, *q;   /* q follows p along memlis  */
    struct  mblock  *fits, *fitsq;
    unsigned len;

    disable(ps);
    if (nbytes == 0) {
        restore(ps);
        return( (int *)SYSERR );
    }
    nbytes = (unsigned)roundew(nbytes);
    fits = NULL;
    q = &memlist;
    for (p = q->mnext ; p != NULL ; q = p,p = p->mnext)
        if ( p->mlen >= nbytes) {
            fitsq = q;
            fits = p;
        }
    if (fits == NULL) {
        restore(ps);
        return( (int *)SYSERR );
    }
    if (nbytes == (len = fits->mlen) ) {
        fitsq->mnext = fits->mnext;
    } else {
        fits->mlen -= nbytes;
    }
    fits = (struct mblock *)(((unsigned)fits) + len - sizeof(int));
    *((unsigned *) fits) = nbytes; /* put size at base */
    restore(ps);
    return( (int *)fits );
}
