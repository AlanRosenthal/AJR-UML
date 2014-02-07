all: fred_fractal alan_fractal

fred_fractal: fred_fractal.o triangle.o sierpinski.o
	g++ fred_fractal.o triangle.o sierpinski.o -o fred_fractal -lsfml-graphics -lsfml-window -lsfml-system

alan_fractal: alan_fractal.o sierpinski.o parallelogram.o rosenthal.o triangle.o
	g++ alan_fractal.o sierpinski.o parallelogram.o rosenthal.o triangle.o -o alan_fractal -lsfml-graphics -lsfml-window -lsfml-system

alan_fractal.o: alan_fractal.cpp
	g++ -c alan_fractal.cpp rosenthal.hpp

fred_fractal.o: fred_fractal.cpp
	g++ -c fred_fractal.cpp sierpinski.hpp

parallelogram.o: parallelogram.cpp
	g++ -c parallelogram.cpp

rosenthal.o: rosenthal.cpp
	g++ -c rosenthal.cpp parallelogram.hpp sierpinski.hpp

triangle.o: triangle.cpp
	g++ -c triangle.cpp triangle.hpp

sierpinski.o: sierpinski.cpp
	g++ -c sierpinski.cpp sierpinski.hpp triangle.hpp

clean:
	rm -rf *.o *.gch fred_fractal alan_fractal
