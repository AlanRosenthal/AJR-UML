all:
	ghc --make ProbA.hs

test:
	make
	cat A-large.in | ./ProbA > A-large.out

test2:
	make
	cat A-small-attempt0.in | ./ProbA

clean:
	rm -rf ProbA *.o *.hi *~