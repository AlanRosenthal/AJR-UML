#include <SFML/Graphics.hpp>
#include "universe.hpp"
#include "planet.hpp"
#include <iostream>
#include <fstream>

using namespace std;

int main(int argc, char* argv[])
{
    Universe universe;
    universe.set_time(0);
    universe.set_delta_time(atof(argv[2]));
    int num_planets;
    float universe_size;
    float pos_x;
    float pos_y;
    float vel_x;
    float vel_y;
    float mass;
    string filename;
    cin >> num_planets;
    cin >> universe_size;
    universe.set_num_planets(num_planets);
    universe.set_universe_size(universe_size);
    for (int i = 0; i < universe.get_num_planets(); i++)
    {
        cin >> pos_x;
        cin >> pos_y;
        cin >> vel_x;
        cin >> vel_y;
        cin >> mass;
        cin >> filename;
        Planet p = Planet(i,pos_x,pos_y,vel_x,vel_y,mass,filename);
        universe.push_planets(p);
    }
    sf::RenderWindow window(sf::VideoMode(500,500),"Solar System");
    window.setFramerateLimit(60);
    int go = 0;
    
    while (window.isOpen())
    {
        sf::Event event;
        while (window.pollEvent(event))
        {
            if (event.type == sf::Event::Closed)
                window.close();
            if (event.type == sf::Event::KeyPressed)
            {
            
            }
        }
        window.clear();
        
        universe.move_all_planets(); 
        universe.draw_all_planets(&window);
        
        
        window.display();
    }
    return 0;
}
