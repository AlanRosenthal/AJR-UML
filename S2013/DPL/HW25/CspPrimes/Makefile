
all: primes.beam

primes.beam: primes.erl
	erlc $<

test:
	perl test.t

clean:
	rm -f *~ *.beam primes.txt erl_crash.dump
