CC = perl colorgcc.pl
CFLAGS = -g -c -I. -I/usr/lib/gcc/x86_64-linux-gnu/4.6.3/include
CXX_CFLAGS = -I.
LDFLAGS=
SOURCES = codejam.c
OBJECTS = $(SOURCES:.c=.o)
EXECUTABLE = codejam

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS) 
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@

.c.o:
	$(CC) $(CFLAGS) $< -o $@ $(CXX_CFLAGS)
clean:
	rm -f *.o $(EXECUTABLE)

depend:
	makedepend -- $(CFLAGS) -- $(SOURCES)
# DO NOT DELETE

codejam.o: /usr/include/stdio.h /usr/include/features.h
codejam.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stddef.h
codejam.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
codejam.o: /usr/lib/gcc/x86_64-linux-gnu/4.6.3/include/stdarg.h
codejam.o: /usr/include/xlocale.h /usr/include/stdlib.h /usr/include/alloca.h
codejam.o: /usr/include/string.h codejam.h
