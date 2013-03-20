
BEAMS=$(shell echo *.erl | perl -pe 's/\.erl\b/.beam/g')

all: $(BEAMS)

%.beam: %.erl
	erlc $<

test:
	perl test.t

clean:
	rm -f *.beam *~
