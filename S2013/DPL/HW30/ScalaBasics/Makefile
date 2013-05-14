
JCS=$(shell echo *.java | perl -lpe 's/\.java\b//g')
SCS=$(shell echo *.scala | perl -lpe 's/\.scala\b//g')

all: $(JCS) $(SCS)

$(JCS): *.java
	javac $@.java

$(SCS): *.scala
	scalac $@.scala

test: all
	perl test.t

clean:
	rm -f *.class Test*.scala *~

.PHONY: all clean
