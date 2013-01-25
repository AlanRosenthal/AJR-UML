
PROGS=$(shell ls *.hs | perl -lpE 's/\.hs\b//')

all: $(PROGS)

$(PROGS): $(shell echo *.hs) 
	ghc --make $@

test: all
	perl test.t

clean:
	rm -rf $(PROGS) *.o *.hi *~
