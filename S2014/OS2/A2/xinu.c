#include <kernel.h>
#include <proc.h>
#include <sem.h>
#include <q.h>

void end_game(void);
void idle_thread(void);
void procA(int);
void procB(int,int);
void procC(int,int);

void end_game(void)
{
    char tmp[100];
    write(1,tmp,sprintf(tmp,"Terminating Xinu...\n"));
}

void idle_thread(void)
{
    char tmp[100];
    int sem = screate(0);

    //a. print a message saying that it’s alive 
    write(1,tmp,sprintf(tmp,"IDLE_THREAD: Starting PID %d...\n",getpid()));

    //b. print a message saying that is has created processes A, B, and C 
    int procA_PID = create(procA,INITSTK,10,"procA",1,sem);
    int procB_PID = create(procB,INITSTK,10,"procB",2,sem,procA_PID);
    int procC_PID = create(procC,INITSTK,10,"procC",2,getpid(),30);
    write(1,tmp,sprintf(tmp,"IDLE_THREAD: Created PROCA (pid: %d), PROCB (pid: %d), and PROCC (pid: %d)...\n",procA_PID,procB_PID,procC_PID));
    ready(procA_PID,0);
    ready(procB_PID,0);
    ready(procC_PID,0);
    
    //c. print a message saying that it is about to suspend itself 
    write(1,tmp,sprintf(tmp,"IDLE_THREAD: Suspending...\n"));
    resched();
//    suspend(getpid()); // cant suspend myself... why not?

    //d. print a message saying that it has been resumed 
    write(1,tmp,sprintf(tmp,"IDLE_THREAD: Resumed...\n"));

    //e. print a message saying that the process table is empty except for NULL and itself, and that it is now about to terminate the entire emulation 
    while(numproc > 1) resched();
    write(1,tmp,sprintf(tmp,"IDLE_THREAD: Process table is empty, Terminating...\n"));
}

void procA(int sem)
{
    char tmp[100];
    int msg;

    //a. print a message saying that it’s alive 
    write(1,tmp,sprintf(tmp,"A: Starting PID %d...\n",getpid()));

    //b. print a message saying that it is about to wait on the semaphore ID that was passed to it as a create argument 
    write(1,tmp,sprintf(tmp,"A: Waiting on Semaphore ID: %d...\n",sem));
    wait(sem);    

    //c. print a message saying that it is awake, and about to wait for a message to be sent to it 
    write(1,tmp,sprintf(tmp,"A: Awakened.  Waiting for message...\n"));
    msg = receive();

    //d. print a message saying that it has received a certain message and is now terminating itself    
    write(1,tmp,sprintf(tmp,"A: Message Received: %d\n",msg));
    write(1,tmp,sprintf(tmp,"A: Terminating...\n"));
    kill(getpid());
}

void procB(int sem, int pid_procA)
{
    char tmp[100];
    int msg = getpid();

    //a. print a message saying that it’s alive 
    write(1,tmp,sprintf(tmp,"B: Starting PID %d...\n",getpid()));

    //b. print a message saying that it’s about to sleep for 2 seconds    
    write(1,tmp,sprintf(tmp,"B: Going to sleep for 2 seconds...\n"));
    sleep(2);
    
    //c. print a message saying that it is awake, and about to signal the semaphore that was passed to it as one of its create arguments 
    write(1,tmp,sprintf(tmp,"B: Awakened. Signaling semaphore...\n"));
    signal(sem,1);
    
    //d. print another message saying that it’s about to sleep for 2 seconds 
    write(1,tmp,sprintf(tmp,"B: Going to sleep for 2 seconds...\n")); 
    sleep(2);

    //e. print a message saying that it is awake, and about to send a certain message to the pid that was passed to it as one of its create arguments 
    write(1,tmp,sprintf(tmp,"B: Awakened. Sending message (%d) to PID %d...\n",msg,pid_procA));
    send(pid_procA,msg);

    //f. print another message saying that it’s about to sleep for 2 seconds 
    write(1,tmp,sprintf(tmp,"B: Going to sleep for 2 seconds...\n"));
    sleep(2);

    //g. print a message saying that it is awake, and is now terminating itself
    write(1,tmp,sprintf(tmp,"B: Awakened. Terminating...\n"));
    kill(getpid());
}

void procC(int pid_idle_thread,int timeout)
{
    char tmp[100];

    //a. print a message saying that it’s alive 
    write(1,tmp,sprintf(tmp,"C: Starting... PID %d\n",getpid()));

    //b. print a message saying that it’s about to sleep for the number of seconds passed to it as a create argument 
    write(1,tmp,sprintf(tmp,"C: Sleeping for %d second(s)...\n",timeout));
    sleep(30);

    //c. print a message saying that it is awake, and is now resuming the INIT process (whose pid it was given as a create argument) 
    write(1,tmp,sprintf(tmp,"C: Awakened.  Resuming PID %d...\n",pid_idle_thread));
    resched();

    //d. print a message saying that it is now terminating itself 
    write(1,tmp,sprintf(tmp,"C: Terminating...\n"));
    kill(getpid());

}

