#include "kernel.h"

void xmain(int);
void end_game(void);
void idle_thread(void);
void procA(int);
void procB(int,int);
void procC(int);


void xmain(int arg)
{
    write(1,"Entering XMAIN...\n",18);
}

void end_game(void)
{
    write(1,"Entering END_GAME...\n",21);
}

void idle_thread(void)
{
    write(1,"Entering IDLE_THREAD...\n",24);
    int procA_PID = create(procA,INITSTK,10,"PROC A",1,15);
    int procB_PID = create(procB,INITSTK,10,"PROC B",2,12,54);
    ready(procA_PID,0);
    ready(procB_PID,0);
    while(1);
}

void procA(int sem)
{
    write(1,"Entering PROCA...\n",18);
    printf("semaphone: %d\n",sem);
    printf("arg1: %X\n",&sem);
    while(1);
}

void procB(int sem, int pid_procA)
{
    write(1,"Entering PROCB...\n",18);
    printf("arg1: %X, arg 2: %X\n",&sem,&pid_procA);
    
    printf("semaphore: %d pid a: %d\n",sem,pid_procA);
    while(1);
}

void procC(int pid_INIT)
{
    write(1,"Entering PROCC...\n",18);
}

