CC = perl colorgcc.pl
CFLAGS = -g -c -I. -I/usr/lib/gcc/x86_64-linux-gnu/4.6.3/include -m32
CXX_CFLAGS = -I.
LDFLAGS= -m32
SOURCES = chprio.c clkinit.c clkint.c create.c ctxsw.c  \
getpid.c getprio.c initialize.c insertd.c kill.c mem.c q.c \
ready.c receive.c recvclr.c resched.c resume.c screate.c sdelete.c send.c signal.c \
sleep10.c sleep.c ssclock.c suspend.c userret.c wait.c wakeup.c xinu.c
OBJECTS = $(SOURCES:.c=.o)
EXECUTABLE = xinu


all: $(SOURCES) $(EXECUTABLE)

	
$(EXECUTABLE): $(OBJECTS) 
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@

.c.o:
	$(CC) $(CFLAGS) $< -o $@ $(CXX_CFLAGS)
clean:
	rm -f *.o $(EXECUTABLE)

depend:
	makedepend --$(CFLAGS) --$(SOURCES)
# DO NOT DELETE

clkinit.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
clkinit.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
clkinit.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
clkinit.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
clkinit.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
clkinit.o: /usr/include/bits/signum.h /usr/include/time.h
clkinit.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
clkinit.o: /usr/include/bits/sigcontext.h
clkinit.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
clkinit.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
clkinit.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
clkinit.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
clkinit.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
clkinit.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
clkinit.o: /usr/include/sys/time.h /usr/include/bits/time.h
clkinit.o: /usr/include/sys/select.h /usr/include/bits/select.h
clkinit.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
clkinit.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
clkinit.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
clkinit.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
clkinit.o: /usr/include/alloca.h /usr/include/ucontext.h
clkinit.o: /usr/include/sys/ucontext.h ./sleep.h
clkint.o: ./sleep.h ./kernel.h ./signal.h /usr/include/features.h
clkint.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
clkint.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
clkint.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
clkint.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
clkint.o: /usr/include/bits/signum.h /usr/include/time.h
clkint.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
clkint.o: /usr/include/bits/sigcontext.h
clkint.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
clkint.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
clkint.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
clkint.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
clkint.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
clkint.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
clkint.o: /usr/include/sys/time.h /usr/include/bits/time.h
clkint.o: /usr/include/sys/select.h /usr/include/bits/select.h
clkint.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
clkint.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
clkint.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
clkint.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
clkint.o: /usr/include/alloca.h /usr/include/ucontext.h
clkint.o: /usr/include/sys/ucontext.h ./q.h
create.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
create.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
create.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
create.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
create.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
create.o: /usr/include/bits/signum.h /usr/include/time.h
create.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
create.o: /usr/include/bits/sigcontext.h
create.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
create.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
create.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
create.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
create.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
create.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
create.o: /usr/include/sys/time.h /usr/include/bits/time.h
create.o: /usr/include/sys/select.h /usr/include/bits/select.h
create.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
create.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
create.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
create.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
create.o: /usr/include/alloca.h /usr/include/ucontext.h
create.o: /usr/include/sys/ucontext.h ./proc.h ./mem.h ./io.h
create.o: /usr/include/string.h /usr/include/xlocale.h
ctxsw.o: ./signal.h /usr/include/features.h /usr/include/bits/predefs.h
ctxsw.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
ctxsw.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
ctxsw.o: /usr/include/bits/sigset.h /usr/include/bits/types.h
ctxsw.o: /usr/include/bits/typesizes.h /usr/include/bits/signum.h
ctxsw.o: /usr/include/time.h /usr/include/bits/siginfo.h
ctxsw.o: /usr/include/bits/sigaction.h /usr/include/bits/sigcontext.h
ctxsw.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
ctxsw.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
ctxsw.o: /usr/include/bits/sigthread.h ./kernel.h /usr/include/stdio.h
ctxsw.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
ctxsw.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
ctxsw.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
ctxsw.o: /usr/include/sys/time.h /usr/include/bits/time.h
ctxsw.o: /usr/include/sys/select.h /usr/include/bits/select.h
ctxsw.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
ctxsw.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
ctxsw.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
ctxsw.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
ctxsw.o: /usr/include/alloca.h /usr/include/ucontext.h
ctxsw.o: /usr/include/sys/ucontext.h ./proc.h
getpid.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
getpid.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
getpid.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
getpid.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
getpid.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
getpid.o: /usr/include/bits/signum.h /usr/include/time.h
getpid.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
getpid.o: /usr/include/bits/sigcontext.h
getpid.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
getpid.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
getpid.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
getpid.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
getpid.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
getpid.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
getpid.o: /usr/include/sys/time.h /usr/include/bits/time.h
getpid.o: /usr/include/sys/select.h /usr/include/bits/select.h
getpid.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
getpid.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
getpid.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
getpid.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
getpid.o: /usr/include/alloca.h /usr/include/ucontext.h
getpid.o: /usr/include/sys/ucontext.h ./proc.h
getprio.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
getprio.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
getprio.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
getprio.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
getprio.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
getprio.o: /usr/include/bits/signum.h /usr/include/time.h
getprio.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
getprio.o: /usr/include/bits/sigcontext.h
getprio.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
getprio.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
getprio.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
getprio.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
getprio.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
getprio.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
getprio.o: /usr/include/sys/time.h /usr/include/bits/time.h
getprio.o: /usr/include/sys/select.h /usr/include/bits/select.h
getprio.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
getprio.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
getprio.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
getprio.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
getprio.o: /usr/include/alloca.h /usr/include/ucontext.h
getprio.o: /usr/include/sys/ucontext.h ./proc.h
initialize.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
initialize.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
initialize.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
initialize.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
initialize.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
initialize.o: /usr/include/bits/signum.h /usr/include/time.h
initialize.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
initialize.o: /usr/include/bits/sigcontext.h
initialize.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
initialize.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
initialize.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
initialize.o: /usr/include/libio.h /usr/include/_G_config.h
initialize.o: /usr/include/wchar.h
initialize.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
initialize.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
initialize.o: /usr/include/sys/time.h /usr/include/bits/time.h
initialize.o: /usr/include/sys/select.h /usr/include/bits/select.h
initialize.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
initialize.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
initialize.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
initialize.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
initialize.o: /usr/include/alloca.h /usr/include/ucontext.h
initialize.o: /usr/include/sys/ucontext.h ./proc.h ./sem.h ./sleep.h ./mem.h
initialize.o: ./tty.h ./q.h ./io.h /usr/include/string.h
initialize.o: /usr/include/xlocale.h
insertd.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
insertd.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
insertd.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
insertd.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
insertd.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
insertd.o: /usr/include/bits/signum.h /usr/include/time.h
insertd.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
insertd.o: /usr/include/bits/sigcontext.h
insertd.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
insertd.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
insertd.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
insertd.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
insertd.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
insertd.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
insertd.o: /usr/include/sys/time.h /usr/include/bits/time.h
insertd.o: /usr/include/sys/select.h /usr/include/bits/select.h
insertd.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
insertd.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
insertd.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
insertd.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
insertd.o: /usr/include/alloca.h /usr/include/ucontext.h
insertd.o: /usr/include/sys/ucontext.h ./q.h
kill.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
kill.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
kill.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
kill.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
kill.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
kill.o: /usr/include/bits/signum.h /usr/include/time.h
kill.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
kill.o: /usr/include/bits/sigcontext.h
kill.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
kill.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
kill.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
kill.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
kill.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
kill.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
kill.o: /usr/include/sys/time.h /usr/include/bits/time.h
kill.o: /usr/include/sys/select.h /usr/include/bits/select.h
kill.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
kill.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
kill.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
kill.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
kill.o: /usr/include/alloca.h /usr/include/ucontext.h
kill.o: /usr/include/sys/ucontext.h ./proc.h ./sem.h ./mem.h ./io.h
mem.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
mem.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
mem.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
mem.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
mem.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
mem.o: /usr/include/bits/signum.h /usr/include/time.h
mem.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
mem.o: /usr/include/bits/sigcontext.h
mem.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
mem.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
mem.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
mem.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
mem.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
mem.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
mem.o: /usr/include/sys/time.h /usr/include/bits/time.h
mem.o: /usr/include/sys/select.h /usr/include/bits/select.h
mem.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
mem.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
mem.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
mem.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
mem.o: /usr/include/alloca.h /usr/include/ucontext.h
mem.o: /usr/include/sys/ucontext.h ./mem.h
q.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
q.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
q.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
q.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
q.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
q.o: /usr/include/bits/signum.h /usr/include/time.h
q.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
q.o: /usr/include/bits/sigcontext.h
q.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
q.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
q.o: /usr/include/bits/sigthread.h /usr/include/stdio.h /usr/include/libio.h
q.o: /usr/include/_G_config.h /usr/include/wchar.h
q.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
q.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
q.o: /usr/include/sys/time.h /usr/include/bits/time.h
q.o: /usr/include/sys/select.h /usr/include/bits/select.h
q.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
q.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
q.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
q.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
q.o: /usr/include/alloca.h /usr/include/ucontext.h
q.o: /usr/include/sys/ucontext.h ./q.h
ready.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
ready.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
ready.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
ready.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
ready.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
ready.o: /usr/include/bits/signum.h /usr/include/time.h
ready.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
ready.o: /usr/include/bits/sigcontext.h
ready.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
ready.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
ready.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
ready.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
ready.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
ready.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
ready.o: /usr/include/sys/time.h /usr/include/bits/time.h
ready.o: /usr/include/sys/select.h /usr/include/bits/select.h
ready.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
ready.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
ready.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
ready.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
ready.o: /usr/include/alloca.h /usr/include/ucontext.h
ready.o: /usr/include/sys/ucontext.h ./proc.h ./q.h
receive.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
receive.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
receive.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
receive.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
receive.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
receive.o: /usr/include/bits/signum.h /usr/include/time.h
receive.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
receive.o: /usr/include/bits/sigcontext.h
receive.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
receive.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
receive.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
receive.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
receive.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
receive.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
receive.o: /usr/include/sys/time.h /usr/include/bits/time.h
receive.o: /usr/include/sys/select.h /usr/include/bits/select.h
receive.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
receive.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
receive.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
receive.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
receive.o: /usr/include/alloca.h /usr/include/ucontext.h
receive.o: /usr/include/sys/ucontext.h ./proc.h
recvclr.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
recvclr.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
recvclr.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
recvclr.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
recvclr.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
recvclr.o: /usr/include/bits/signum.h /usr/include/time.h
recvclr.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
recvclr.o: /usr/include/bits/sigcontext.h
recvclr.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
recvclr.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
recvclr.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
recvclr.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
recvclr.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
recvclr.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
recvclr.o: /usr/include/sys/time.h /usr/include/bits/time.h
recvclr.o: /usr/include/sys/select.h /usr/include/bits/select.h
recvclr.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
recvclr.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
recvclr.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
recvclr.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
recvclr.o: /usr/include/alloca.h /usr/include/ucontext.h
recvclr.o: /usr/include/sys/ucontext.h ./proc.h
resched.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
resched.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
resched.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
resched.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
resched.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
resched.o: /usr/include/bits/signum.h /usr/include/time.h
resched.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
resched.o: /usr/include/bits/sigcontext.h
resched.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
resched.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
resched.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
resched.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
resched.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
resched.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
resched.o: /usr/include/sys/time.h /usr/include/bits/time.h
resched.o: /usr/include/sys/select.h /usr/include/bits/select.h
resched.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
resched.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
resched.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
resched.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
resched.o: /usr/include/alloca.h /usr/include/ucontext.h
resched.o: /usr/include/sys/ucontext.h ./proc.h ./q.h
resume.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
resume.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
resume.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
resume.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
resume.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
resume.o: /usr/include/bits/signum.h /usr/include/time.h
resume.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
resume.o: /usr/include/bits/sigcontext.h
resume.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
resume.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
resume.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
resume.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
resume.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
resume.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
resume.o: /usr/include/sys/time.h /usr/include/bits/time.h
resume.o: /usr/include/sys/select.h /usr/include/bits/select.h
resume.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
resume.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
resume.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
resume.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
resume.o: /usr/include/alloca.h /usr/include/ucontext.h
resume.o: /usr/include/sys/ucontext.h ./proc.h
screate.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
screate.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
screate.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
screate.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
screate.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
screate.o: /usr/include/bits/signum.h /usr/include/time.h
screate.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
screate.o: /usr/include/bits/sigcontext.h
screate.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
screate.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
screate.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
screate.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
screate.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
screate.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
screate.o: /usr/include/sys/time.h /usr/include/bits/time.h
screate.o: /usr/include/sys/select.h /usr/include/bits/select.h
screate.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
screate.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
screate.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
screate.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
screate.o: /usr/include/alloca.h /usr/include/ucontext.h
screate.o: /usr/include/sys/ucontext.h ./proc.h ./q.h ./sem.h
sdelete.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
sdelete.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
sdelete.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
sdelete.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
sdelete.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
sdelete.o: /usr/include/bits/signum.h /usr/include/time.h
sdelete.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
sdelete.o: /usr/include/bits/sigcontext.h
sdelete.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
sdelete.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
sdelete.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
sdelete.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
sdelete.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
sdelete.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
sdelete.o: /usr/include/sys/time.h /usr/include/bits/time.h
sdelete.o: /usr/include/sys/select.h /usr/include/bits/select.h
sdelete.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
sdelete.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
sdelete.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
sdelete.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
sdelete.o: /usr/include/alloca.h /usr/include/ucontext.h
sdelete.o: /usr/include/sys/ucontext.h ./proc.h ./q.h ./sem.h
send.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
send.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
send.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
send.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
send.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
send.o: /usr/include/bits/signum.h /usr/include/time.h
send.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
send.o: /usr/include/bits/sigcontext.h
send.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
send.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
send.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
send.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
send.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
send.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
send.o: /usr/include/sys/time.h /usr/include/bits/time.h
send.o: /usr/include/sys/select.h /usr/include/bits/select.h
send.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
send.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
send.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
send.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
send.o: /usr/include/alloca.h /usr/include/ucontext.h
send.o: /usr/include/sys/ucontext.h ./proc.h
signal.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
signal.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
signal.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
signal.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
signal.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
signal.o: /usr/include/bits/signum.h /usr/include/time.h
signal.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
signal.o: /usr/include/bits/sigcontext.h
signal.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
signal.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
signal.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
signal.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
signal.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
signal.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
signal.o: /usr/include/sys/time.h /usr/include/bits/time.h
signal.o: /usr/include/sys/select.h /usr/include/bits/select.h
signal.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
signal.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
signal.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
signal.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
signal.o: /usr/include/alloca.h /usr/include/ucontext.h
signal.o: /usr/include/sys/ucontext.h ./proc.h ./q.h ./sem.h
sleep10.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
sleep10.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
sleep10.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
sleep10.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
sleep10.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
sleep10.o: /usr/include/bits/signum.h /usr/include/time.h
sleep10.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
sleep10.o: /usr/include/bits/sigcontext.h
sleep10.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
sleep10.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
sleep10.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
sleep10.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
sleep10.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
sleep10.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
sleep10.o: /usr/include/sys/time.h /usr/include/bits/time.h
sleep10.o: /usr/include/sys/select.h /usr/include/bits/select.h
sleep10.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
sleep10.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
sleep10.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
sleep10.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
sleep10.o: /usr/include/alloca.h /usr/include/ucontext.h
sleep10.o: /usr/include/sys/ucontext.h ./proc.h ./q.h ./sleep.h
sleep.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
sleep.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
sleep.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
sleep.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
sleep.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
sleep.o: /usr/include/bits/signum.h /usr/include/time.h
sleep.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
sleep.o: /usr/include/bits/sigcontext.h
sleep.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
sleep.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
sleep.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
sleep.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
sleep.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
sleep.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
sleep.o: /usr/include/sys/time.h /usr/include/bits/time.h
sleep.o: /usr/include/sys/select.h /usr/include/bits/select.h
sleep.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
sleep.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
sleep.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
sleep.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
sleep.o: /usr/include/alloca.h /usr/include/ucontext.h
sleep.o: /usr/include/sys/ucontext.h ./proc.h ./q.h ./sleep.h
ssclock.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
ssclock.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
ssclock.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
ssclock.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
ssclock.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
ssclock.o: /usr/include/bits/signum.h /usr/include/time.h
ssclock.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
ssclock.o: /usr/include/bits/sigcontext.h
ssclock.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
ssclock.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
ssclock.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
ssclock.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
ssclock.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
ssclock.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
ssclock.o: /usr/include/sys/time.h /usr/include/bits/time.h
ssclock.o: /usr/include/sys/select.h /usr/include/bits/select.h
ssclock.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
ssclock.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
ssclock.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
ssclock.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
ssclock.o: /usr/include/alloca.h /usr/include/ucontext.h
ssclock.o: /usr/include/sys/ucontext.h ./proc.h ./q.h ./sleep.h
suspend.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
suspend.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
suspend.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
suspend.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
suspend.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
suspend.o: /usr/include/bits/signum.h /usr/include/time.h
suspend.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
suspend.o: /usr/include/bits/sigcontext.h
suspend.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
suspend.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
suspend.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
suspend.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
suspend.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
suspend.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
suspend.o: /usr/include/sys/time.h /usr/include/bits/time.h
suspend.o: /usr/include/sys/select.h /usr/include/bits/select.h
suspend.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
suspend.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
suspend.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
suspend.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
suspend.o: /usr/include/alloca.h /usr/include/ucontext.h
suspend.o: /usr/include/sys/ucontext.h ./proc.h
userret.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
userret.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
userret.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
userret.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
userret.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
userret.o: /usr/include/bits/signum.h /usr/include/time.h
userret.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
userret.o: /usr/include/bits/sigcontext.h
userret.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
userret.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
userret.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
userret.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
userret.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
userret.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
userret.o: /usr/include/sys/time.h /usr/include/bits/time.h
userret.o: /usr/include/sys/select.h /usr/include/bits/select.h
userret.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
userret.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
userret.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
userret.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
userret.o: /usr/include/alloca.h /usr/include/ucontext.h
userret.o: /usr/include/sys/ucontext.h
wait.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
wait.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
wait.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
wait.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
wait.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
wait.o: /usr/include/bits/signum.h /usr/include/time.h
wait.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
wait.o: /usr/include/bits/sigcontext.h
wait.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
wait.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
wait.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
wait.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
wait.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
wait.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
wait.o: /usr/include/sys/time.h /usr/include/bits/time.h
wait.o: /usr/include/sys/select.h /usr/include/bits/select.h
wait.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
wait.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
wait.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
wait.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
wait.o: /usr/include/alloca.h /usr/include/ucontext.h
wait.o: /usr/include/sys/ucontext.h ./proc.h ./q.h ./sem.h
wakeup.o: ./conf.h ./kernel.h ./signal.h /usr/include/features.h
wakeup.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
wakeup.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
wakeup.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
wakeup.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
wakeup.o: /usr/include/bits/signum.h /usr/include/time.h
wakeup.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
wakeup.o: /usr/include/bits/sigcontext.h
wakeup.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
wakeup.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
wakeup.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
wakeup.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
wakeup.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
wakeup.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
wakeup.o: /usr/include/sys/time.h /usr/include/bits/time.h
wakeup.o: /usr/include/sys/select.h /usr/include/bits/select.h
wakeup.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
wakeup.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
wakeup.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
wakeup.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
wakeup.o: /usr/include/alloca.h /usr/include/ucontext.h
wakeup.o: /usr/include/sys/ucontext.h ./proc.h ./q.h ./sleep.h
xinu.o: ./kernel.h ./signal.h /usr/include/features.h
xinu.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
xinu.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
xinu.o: /usr/include/gnu/stubs-64.h /usr/include/bits/sigset.h
xinu.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
xinu.o: /usr/include/bits/signum.h /usr/include/time.h
xinu.o: /usr/include/bits/siginfo.h /usr/include/bits/sigaction.h
xinu.o: /usr/include/bits/sigcontext.h
xinu.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
xinu.o: /usr/include/bits/sigstack.h /usr/include/bits/pthreadtypes.h
xinu.o: /usr/include/bits/sigthread.h /usr/include/stdio.h
xinu.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
xinu.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
xinu.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
xinu.o: /usr/include/sys/time.h /usr/include/bits/time.h
xinu.o: /usr/include/sys/select.h /usr/include/bits/select.h
xinu.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
xinu.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
xinu.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
xinu.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
xinu.o: /usr/include/alloca.h /usr/include/ucontext.h
xinu.o: /usr/include/sys/ucontext.h ./proc.h ./sem.h ./q.h
