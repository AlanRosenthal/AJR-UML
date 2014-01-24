SFMLPATH=~/Documents/SFML-2.1/
g++ -c main.cpp -I${SFMLPATH}include
g++ main.o -o sfml-app -L${SFMLPATH}/lib -lsfml-graphics -lsfml-window -lsfml-system
export LD_LIBRARY_PATH=${SFMLPATH}/lib && ./sfml-app
