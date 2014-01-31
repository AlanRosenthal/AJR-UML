all: nbody/solarsystem

nbody/solarsystem: main.o universe.o planet.o
	g++ main.o universe.o planet.o -o nbody/solarsystem -lsfml-graphics -lsfml-window -lsfml-system

main.o: main.cpp
	g++ -c main.cpp universe.hpp planet.hpp

universe.o: universe.cpp
	g++ -c universe.cpp universe.hpp planet.hpp

planet.o: planet.cpp
	g++ -c planet.cpp planet.hpp

clean:
	rm -rf *.o *.gch nbody/solarsystem
