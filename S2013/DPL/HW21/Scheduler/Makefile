
BINARY=uml

all: $(BINARY)

%: %.pl
	gplc --no-top-level $<

test:
	perl test.t

clean:
	rm -f *~ $(BINARY) *.o
