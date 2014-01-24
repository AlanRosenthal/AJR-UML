g++ -c main.cpp -I/home/alanrosenthal/Documents/SFML-2.1/include
g++ main.o -o sfml-app -L/home/alanrosenthal/Documents/SFML-2.1/lib -lsfml-graphics -lsfml-window -lsfml-system
export LD_LIBRARY_PATH=/home/alanrosenthal/Documents/SFML-2.1/lib && ./sfml-app


