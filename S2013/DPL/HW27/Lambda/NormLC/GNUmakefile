
BINARY=NormLC

all: $(BINARY)

$(BINARY): *.hs
	ghc --make $(BINARY)

clean:
	rm -f $(BINARY) *.o *.hi *~

.PHONY: all clean
