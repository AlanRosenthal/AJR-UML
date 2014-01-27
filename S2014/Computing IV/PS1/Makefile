all: solarsystem

solarsystem: main.o
	g++ main.o -o solarsystem -lsfml-graphics -lsfml-window -lsfml-system

main.o: main.cpp
	g++ -c main.cpp planets.hpp

clean: 
	rm -rf *.o *.gch sfml-app
