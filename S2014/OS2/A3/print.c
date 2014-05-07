#include <kernel.h>
#include <proc.h>
#include <q.h>
#include <sleep.h>
#include <sem.h>

void print_proc_table(void);
void proc_state_to_string(int state,char str[]);
void print_sleep_queue(void);
void print_priority_queue(void);
void print_sem_queue(void);

void print_proc_table(void)
{
    int i;
    char tmp[100];
    char * proc_state[8] = { "", "CURRENT", "FREE", "READY", "RECEIVE", "SLEEP", "SUSPEND", "WAIT" };
    write(1,tmp,sprintf(tmp,"PROC LIST\n",i,tmp));
    for (i = 0;i < NPROC; i++)
    {
        write(1,tmp,sprintf(tmp,"PROC %d - STATE: %s\n",i,proc_state[(&proctab[i])->pstate]));
    }
    write(1,tmp,sprintf(tmp,"\n",i,tmp));
}

void proc_state_to_string(int state,char str[])
{
    switch(state)
    {
        case 1:
            strcpy(str,"CURRENT");
            break;
        case 2:
            strcpy(str,"FREE");
            break;
        case 3:
            strcpy(str,"READY");
            break;
        case 4:
            strcpy(str,"RECEIVE");
            break;
        case 5:
            strcpy(str,"SLEEP");
            break;
        case 6:
            strcpy(str,"SUSPEND");
            break;
        case 7:
            strcpy(str,"WAIT");
            break;
    }
}

void print_sleep_queue(void)
{
    char tmp[100];
    write(1,tmp,sprintf(tmp,"SLEEP QUEUE\n"));
    int queue = clockq;
    while (queue != -1)
    {
        int key = q[queue].qkey;
        if ((key != MAXINT) && (key != MININT))
        {
            write(1,tmp,sprintf(tmp,"id: %d\tkey: %d\n",queue,q[queue].qkey));
        }
        queue = q[queue].qnext;
    }
    write(1,tmp,sprintf(tmp,"\n"));
}
void print_priority_queue(void)
{
    char tmp[100];
    write(1,tmp,sprintf(tmp,"PRIORITY QUEUE\n"));
    int queue = rdyhead;
    while (queue != -1)
    {
        int key = q[queue].qkey;
        if ((key != MAXINT) && (key != MININT))
        {
            write(1,tmp,sprintf(tmp,"id: %d\tkey: %d\n",queue,q[queue].qkey));
        }
        queue = q[queue].qnext;
    }
    write(1,tmp,sprintf(tmp,"\n"));    
}
void print_sem_queue(void)
{
    char tmp[100];
    int i;
    char * sem_state[3] = { "","FREE","USED" };
    write(1,tmp,sprintf(tmp,"SEMAPHORE TABLE/QUEUE\n"));
    for (i=0 ; i<NSEM ; i++)
    {
        int queue = (&semaph[i])->sqhead;
        write(1,tmp,sprintf(tmp,"SEM %d - STATE: %s\n",i,sem_state[(&semaph[i])->sstate])); 
        while (queue != -1)
        {
            int key = q[queue].qkey;
            if ((key != MAXINT) && (key != MININT))
            {
                write(1,tmp,sprintf(tmp,"\tid: %d\tkey: %d\n",queue,q[queue].qkey));
            }
            queue = q[queue].qnext;
        }
    }
    write(1,tmp,sprintf(tmp,"\n"));    
}