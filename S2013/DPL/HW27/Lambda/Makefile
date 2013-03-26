
all: Lambda

Lambda: *.hs
	ghc --make Lambda
	(cd NormLC && make)

test:
	perl test.t

clean:
	rm -f Lambda *.o *.hi *~
	(cd NormLC && make clean)

.PHONY: all clean
