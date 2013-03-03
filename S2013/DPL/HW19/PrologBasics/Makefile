
all:
	@echo "Nothing to do at build time."

%: %.pl
	gplc --no-top-level $<

test:
	perl test.t

clean:
	rm -f *~
