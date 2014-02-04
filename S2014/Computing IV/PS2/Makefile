all: triangle

triangle: main.o triangle.o
	g++ main.o triangle.o -o triangle -lsfml-graphics -lsfml-window -lsfml-system

main.o: main.cpp
	g++ -c main.cpp triangle.hpp

triangle.o: triangle.cpp
	g++ -c triangle.cpp triangle.hpp

clean:
	rm -rf *.o *.gch triangle
