
PROG=$(shell basename `pwd`)

all:
	ghc --make $(PROG)

test: all
	perl test.t

clean:
	rm -rf $(PROG) *.o *.hi *~
