#include <SFML/Graphics.hpp>
#include <cmath>
#include "rosenthal.hpp"
#include <iostream>

using namespace std;

int main(int argc, char* argv[])
{
    if (argc < 6)
    {
        cout << argv[0] <<" [width] [height] [recursion depth a] [recursion depth b] [percent]" << endl;
        return -1;
    }
    int deptha = atoi(argv[3]);
    int depthb = atoi(argv[4]);
    int width = atof(argv[1]);
    int height = atof(argv[2]);
    float percent = atof(argv[5]);
    Rosenthal rosenthal(width,height, deptha, depthb, percent);
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
        window.draw(rosenthal);
        window.display();
    }
    return 0;
}
