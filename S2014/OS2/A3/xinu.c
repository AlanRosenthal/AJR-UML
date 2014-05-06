#include <kernel.h>
#include <proc.h>
#include <sem.h>
#include <sleep.h>
#include <fcntl.h>

void xmain(void);
void end_game(void);
void idle_thread(void);
void procA(int);
void procB(int,int);
void procC(int,int);

extern int errno;

void xmain(void)
{
    char tmp[100];
    write(1,tmp,sprintf(tmp,"XMAIN: Starting PID %d...\n",getpid()));
    int idle_thread_pid = create(idle_thread,INITSTK,20,"idle_thread",0);
    resume(idle_thread_pid);
    while(numproc > 1) 
    {
        resched();
    }
}

void end_game(void)
{
    char tmp[100];
    write(1,tmp,sprintf(tmp,"Terminating Xinu...\n"));
}

void idle_thread(void)
{
    char tmp[100];
    char buffer[100];
    int i;
    while(1)
    {
        int count;
        //setup nonblocking io
        int flags = fcntl(1, F_GETFL, 0);
        if(fcntl(1, F_SETFL, flags | O_NONBLOCK))
        {
            //failed
        }
        count = read(1, buffer, 100);
        if(count < 0 && errno == EAGAIN) {
            sleep10(5);//nothing to read, give up the cpu
        }
        else if(count >= 0) {
            char * command;
            char * arg;
            char * arg1;
            char * arg2;
            command = strtok(buffer," \n");
            //show
            if (!strcmp("show",command))
            {
                arg = strtok(NULL, " \n");
                if (arg == NULL)
                {
                    write(1,tmp,sprintf(tmp,"show <arg>\n",command,arg));
                }
                //show proc
                else if (!strcmp("proc",arg))
                {
                    print_proc_table();
                }
                //show priority
                else if (!strcmp("priority",arg))
                {
                    print_priority_queue();
                }
                //show sleep
                else if (!strcmp("sleep",arg))
                {
                    print_sleep_queue();
                }
                //show sem
                else if (!strcmp("sem",arg))
                {
                    print_sem_queue();
                }
                //invalid
                else 
                {
                    write(1,tmp,sprintf(tmp,"show <arg>\n"));
                    write(1,tmp,sprintf(tmp,"\tproc - Process Table\n"));
                    write(1,tmp,sprintf(tmp,"\tpriority - Priority Queue\n"));
                    write(1,tmp,sprintf(tmp,"\tsleep - Sleep Queue\n"));
                    write(1,tmp,sprintf(tmp,"\tsem – Semaphore Table/Queue\n"));
                }
            }
            //create
            else if (!strcmp("create",command))
            {
                arg = strtok(NULL, " \n");
                if (arg == NULL)
                {
                    write(1,tmp,sprintf(tmp,"create <proc_name> <args>\n",command,arg));
                }
                //create procA
                else if (!strcmp("procA",arg))
                {
                    arg1 = strtok(NULL, " \n");
                    if (arg1 == NULL)
                    {
                        write(1,tmp,sprintf(tmp,"create procA <sem>\n"));
                    }
                    else
                    {
                        int procA_PID = create(procA,INITSTK,10,"procA",1,atoi(arg1));
                        write(1,tmp,sprintf(tmp,"CREATED (%s) PID %d\n",arg,procA_PID));
                    }
                }
                //show procB
                else if (!strcmp("procB",arg))
                {
                    arg1 = strtok(NULL, " \n");
                    arg2 = strtok(NULL, " \n");
                    if (arg2 == NULL)
                    {
                        write(1,tmp,sprintf(tmp,"create procB <sem> <pid_procA>\n"));
                    }
                    else
                    {
                        int procB_PID = create(procB,INITSTK,10,"procB",2,atoi(arg1),atoi(arg2));
                        write(1,tmp,sprintf(tmp,"CREATED (%s) PID %d\n",arg,procB_PID));
                    }
                }
                //show procC
                else if (!strcmp("procC",arg))
                {
                    arg1 = strtok(NULL, " \n");
                    arg2 = strtok(NULL, " \n");
                    if (arg2 == NULL)
                    {
                        write(1,tmp,sprintf(tmp,"create procC <pid_idle_thread> <timeout>\n"));
                    }
                    else
                    {
                        int procC_PID = create(procC,INITSTK,10,"procC",2,atoi(arg1),atoi(arg2));
                        write(1,tmp,sprintf(tmp,"CREATED (%s) PID %d\n",arg,procC_PID));
                    }
                }
                else
                {
                    write(1,tmp,sprintf(tmp,"create <arg> [args]\n"));
                    write(1,tmp,sprintf(tmp,"\tprocA <sem>\n"));
                    write(1,tmp,sprintf(tmp,"\tprocB <sem> <pid_procA>\n"));
                    write(1,tmp,sprintf(tmp,"\tprocC <pid_idle_thread> <timeout>\n"));
                }
            }
            //resume
            else if (!strcmp("resume",command))
            {
                arg = strtok(NULL, " \n");
                if (arg == NULL)
                {
                    write(1,tmp,sprintf(tmp,"resume <pid>\n"));
                }
                resume(atoi(arg));
            }
            //suspend
            else if (!strcmp("suspend",command))
            {
                arg = strtok(NULL, " \n");
                if (arg == NULL)
                {
                    write(1,tmp,sprintf(tmp,"suspend <pid>\n"));
                }
                suspend(atoi(arg));
            }
            //kill
            else if (!strcmp("kill",command))
            {
                arg = strtok(NULL, " \n");
                if (arg == NULL)
                {
                    write(1,tmp,sprintf(tmp,"kill <pid>\n"));
                }
                kill(atoi(arg));
            }
            //sem
            else if (!strcmp("sem",command))
            {
                arg = strtok(NULL, " \n");
                if (arg == NULL)
                {
                    write(1,tmp,sprintf(tmp,"sem <arg> <arg>\n"));
                }
                else if (!strcmp("create",arg))
                {
                    arg1 = strtok(NULL, " \n");
                    if (arg1 == NULL)
                    {
                        write(1,tmp,sprintf(tmp,"sem create <count>\n"));
                    }
                    else
                    {
                        write(1,tmp,sprintf(tmp,"CREATED SEM %d\n",screate(atoi(arg1))));
                    }
                }
                else if (!strcmp("signal",arg))
                {
                    arg1 = strtok(NULL, " \n");
                    if (arg1 == NULL)
                    {
                        write(1,tmp,sprintf(tmp,"sem signal <id>\n"));
                    }
                    else
                    {
                        write(1,tmp,sprintf(tmp,"SIGNILING SEM %d\n",signal(atoi(arg1))));
                    }
                }
                else
                {
                    write(1,tmp,sprintf(tmp,"sem <arg> <arg>\n"));
                    write(1,tmp,sprintf(tmp,"\tcreate <count>\n"));
                    write(1,tmp,sprintf(tmp,"\tsignal <id>\n"));
                }
            }
            //help
            else if (!strcmp("help",command))
            {
                write(1,tmp,sprintf(tmp,"LIST OF COMMANDS\n"));
                write(1,tmp,sprintf(tmp,"show <arg>\n"));
                write(1,tmp,sprintf(tmp,"\tproc - Process Table\n"));
                write(1,tmp,sprintf(tmp,"\tpriority - Priority Queue\n"));
                write(1,tmp,sprintf(tmp,"\tsleep - Sleep Queue\n"));
                write(1,tmp,sprintf(tmp,"\tsem – Semaphore Table/Queue\n"));
                write(1,tmp,sprintf(tmp,"create <arg> [args]\n"));
                write(1,tmp,sprintf(tmp,"\tprocA <sem>\n"));
                write(1,tmp,sprintf(tmp,"\tprocB <sem> <pid_procA>\n"));
                write(1,tmp,sprintf(tmp,"\tprocC <pid_idle_thread> <timeout>\n"));
                write(1,tmp,sprintf(tmp,"resume <pid>\n"));
                write(1,tmp,sprintf(tmp,"suspend <pid>\n"));
                write(1,tmp,sprintf(tmp,"kill <pid>\n"));
                write(1,tmp,sprintf(tmp,"sem <arg> <arg>\n"));
                write(1,tmp,sprintf(tmp,"\tcreate <count>\n"));
                write(1,tmp,sprintf(tmp,"\tsignal <id>\n"));
                write(1,tmp,sprintf(tmp,"help\n"));
            }
            //invlaid
            else
            {
                write(1,tmp,sprintf(tmp,"Invalid Command\n"));
            }
        }
        else {
            //failed
        }
    }
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
    //kill(getpid());
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
    signal(sem);
    
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
    //kill(getpid());
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
    resume(pid_idle_thread);

    //d. print a message saying that it is now terminating itself 
    write(1,tmp,sprintf(tmp,"C: Terminating...\n"));
    //kill(getpid());

}
