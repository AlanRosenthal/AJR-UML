
all: Lambda

Lambda: *.hs
	ghc -O2 --make Lambda

test:
	perl test.t

clean:
	rm -f Lambda *.o *.hi *~
	(cd NormLC && make clean)

.PHONY: all clean
