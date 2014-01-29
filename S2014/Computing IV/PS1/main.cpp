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
            Planet p(pos_x,pos_y,vel_x,vel_y,mass,filename);
            universe.add_planets(p);
        }
        file.close();
    }

    sf::RenderWindow window(sf::VideoMode(500,500),"Solar System");
    window.setFramerateLimit(60);

    int i;
    for (i = 0;i < 3;i++)
    {
    
    }

/*    Universe::Planet sun, mercury, venus, earth, mars;

    sun.shape = sf::CircleShape(20.f);
    sun.shape.setFillColor(sf::Color::Yellow);
    sun.pos_x = 0;
    sun.pos_y = 0;
    sun.mass= 1.9890e+30;
    
    mercury.shape = sf::CircleShape(10.f);
    mercury.shape.setFillColor(sf::Color::Green);
    mercury.pos_x = 5.7900e+10;
    mercury.pos_y = 0;
    mercury.mass = 3.3020e+23;
    
    venus.shape = sf::CircleShape(10.f);
    venus.shape.setFillColor(sf::Color::Magenta);
    venus.pos_x = 1.0820e+11;
    venus.pos_y = 0;
    venus.mass = 4.8690e+24;
    
    earth.shape = sf::CircleShape(10.f);
    earth.shape.setFillColor(sf::Color::Blue);
    earth.pos_x = 1.4960e+11;
    earth.pos_y = 0;
    earth.mass = 5.9740e+24;
    
    mars.shape = sf::CircleShape(10.f);
    mars.shape.setFillColor(sf::Color::Red);
    mars.pos_x = 2.2790e+11;
    mars.pos_y = 0;
    mars.mass = 6.4190e+23;
*/

    while (window.isOpen())
    {
        sf::Event event;
        while (window.pollEvent(event))
        {
            if (event.type == sf::Event::Closed)
                window.close();
        }
        window.clear();

/*        window.draw(sun.shape);
        window.draw(mercury.shape);
        window.draw(venus.shape);
        window.draw(earth.shape);
        window.draw(mars.shape);*/
        window.display();
    }
    return 0;
}
