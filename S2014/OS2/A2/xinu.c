#include "kernel.h"

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
}

