#include <SFML/Graphics.hpp>
#include <cmath>
#include "triangle.hpp"
#include "sierpinski.hpp"
#include <iostream>

using namespace std;

int main(int argc, char* argv[])
{
    if (argc < 3)
    {
        cout << argv[0] <<" [side lenght] [recursion depth]" << endl;
        return -1;
    }
    int depth = atoi(argv[2]);
    int side = atof(argv[1]);
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
