all:
	ghc --make ProbB.hs

test2:
	make
	cat ./test/B-small-attempt3.in | ./ProbB > ./test/B-small-attempt3.out

clean:
	rm -rf ProbB *.o *.hi *~