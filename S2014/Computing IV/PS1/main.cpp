#include <SFML/Graphics.hpp>
#include "universe.hpp"
#include "planet.hpp"
#include <iostream>
#include <fstream>

using namespace std;

int main(int argc, char* argv[])
{
    Universe universe;

    //read in file
    ifstream file(argv[3]);
    if (file.is_open())
    {
        int num_planets;
        float universe_size;
        float pos_x;
        float pos_y;
        float vel_x;
        float vel_y;
        float mass;
        string filename;
        
        file >> num_planets;
        file >> universe_size;
        universe.set_num_planets(num_planets);
        universe.set_universe_size(universe_size);

        for (int i = 0; i < universe.get_num_planets(); i++)
        {
            file >> pos_x;
            file >> pos_y;
            file >> vel_x;
            file >> vel_y;
            file >> mass;
            file >> filename;
            //Planet p(pos_x,pos_y,vel_x,vel_y,mass,filename);
        }
        file.close();
    }

    sf::RenderWindow window(sf::VideoMode(500,500),"Solar System");
    window.setFramerateLimit(60);

    while (window.isOpen())
    {
        sf::Event event;
        while (window.pollEvent(event))
        {
            if (event.type == sf::Event::Closed)
                window.close();
        }
        window.clear();

        window.display();
    }
    return 0;
}
