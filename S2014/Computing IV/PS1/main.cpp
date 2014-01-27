#include <SFML/Graphics.hpp>
#include "universe.hpp"
#include <iostream>
#include <fstream>

using namespace std;

int main(int argc, char* argv[])
{
    Universe universe;
    Universe::Planet p[5];
    ifstream file(argv[3]);
    if (file.is_open())
    {
        file >> universe.num_planets;
        file >> universe.universe_size;
        cout << "TEST\n";
        for (int i = 0; i < universe.num_planets; i++)
        {
            file >> p[i].pos_x;
            file >> p[i].pos_y;
            file >> p[i].vel_x;
            file >> p[i].vel_y;
            file >> p[i].mass;
            file >> p[i].filename;
        }
        file.close();
    }
    cout << universe.num_planets << "\n";
    cout << universe.universe_size << "\n";
    for (int i = 0;i < 5;i++)
    {
        cout << "NUMBER " << i << "\n";
        cout << "pos: " << p[i].pos_x << "," << p[i].pos_y << "\n";
        cout << "vel: " << p[i].vel_x << "," << p[i].vel_x << "\n";
        cout << "mass: " << p[i].mass << "\n";
        cout << "file: " << p[i].filename << "\n";
    }



    sf::RenderWindow window(sf::VideoMode(500,500),"Solar System");
    window.setFramerateLimit(60);

    int i;
    for (i = 0;i < 3;i++)
    {
    
    }

    Universe::Planet sun, mercury, venus, earth, mars;

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

    float time = 0;
    float deltaTime = 1;

    while (window.isOpen())
    {
        sf::Event event;
        while (window.pollEvent(event))
        {
            if (event.type == sf::Event::Closed)
                window.close();
        }
        window.clear();

        window.draw(sun.shape);
        window.draw(mercury.shape);
        window.draw(venus.shape);
        window.draw(earth.shape);
        window.draw(mars.shape);
        window.display();
    }
    return 0;
}
