#include <SFML/Graphics.hpp>
#include <cmath>
#include "triangle.hpp"
#include "sierpinski.hpp"
#include <iostream>

using namespace std;

void recurse(Sierpinski *sierpinski,int depth);

int main(int argc, char* argv[])
{
    if (argc < 3)
    {
        cout << "triangle [recursion depth] [side length]" << endl;
        return -1;
    }
    int depth = atoi(argv[1]);
    int side = atof(argv[2]);
    Sierpinski sierpinski(side, depth);
    
    sf::RenderWindow window(sf::VideoMode(700,700),"Solar System");
    window.setFramerateLimit(60);
    while(window.isOpen())
    {
        sf::Event event;
        while (window.pollEvent(event))
        {
            if (event.type == sf::Event::Closed)
                window.close();
        }
        window.clear();
        window.draw(sierpinski);
        window.display();
    }
    return 0;
}
