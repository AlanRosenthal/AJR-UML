CC = perl colorgcc.pl
CFLAGS = -g -c -I. -I/usr/lib/gcc/x86_64-linux-gnu/4.6.3/include
CXX_CFLAGS = -I.
LDFLAGS= -lgc
SOURCES = codejam.c
OBJECTS = $(SOURCES:.c=.o)
EXECUTABLE = codejam

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS) 
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@

.c.o:
	$(CC) $(CFLAGS) $< -o $@ $(CXX_CFLAGS)

clean:
	rm -f *.o $(EXECUTABLE)

depend:
	makedepend -- $(CFLAGS) -- $(SOURCES)
# DO NOT DELETE

codejam.o: /usr/include/stdio.h /usr/include/features.h
codejam.o: /usr/include/bits/predefs.h /usr/include/sys/cdefs.h
codejam.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
codejam.o: /usr/include/gnu/stubs-64.h
codejam.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
codejam.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
codejam.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
codejam.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
codejam.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
codejam.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
codejam.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
codejam.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
codejam.o: /usr/include/sys/types.h /usr/include/time.h
codejam.o: /usr/include/sys/select.h /usr/include/bits/select.h
codejam.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
codejam.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
codejam.o: /usr/include/alloca.h /usr/include/string.h /usr/include/xlocale.h
codejam.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/float.h
codejam.o: /usr/include/gc/gc.h /usr/include/gc/gc_version.h
codejam.o: /usr/include/gc/gc_config_macros.h codejam.h
