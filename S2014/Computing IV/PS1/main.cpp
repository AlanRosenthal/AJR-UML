#include <SFML/Graphics.hpp>
#include "planets.hpp"
#include <iostream>

using namespace std;

int main()
{
    float G = 6.67e-11;

    sf::RenderWindow window(sf::VideoMode(500, 500), "Solar System");
    window.setFramerateLimit(60);

    Planet sun, mercury, venus, earth, mars;

    sun.shape = sf::CircleShape(20.f);
    sun.shape.setFillColor(sf::Color::Yellow);
    sun.update_pos(0,0);
    sun.mass= 1.9890e+30;
    
    mercury.shape = sf::CircleShape(10.f);
    mercury.shape.setFillColor(sf::Color::Green);
    mercury.update_pos(5.7900e+10,0);
    mercury.mass = 3.3020e+23;
    
    venus.shape = sf::CircleShape(10.f);
    venus.shape.setFillColor(sf::Color::Magenta);
    venus.update_pos(1.0820e+11,0);
    venus.mass = 4.8690e+24;
    
    earth.shape = sf::CircleShape(10.f);
    earth.shape.setFillColor(sf::Color::Blue);
    earth.update_pos(1.4960e+11,0);
    earth.mass = 5.9740e+24;
    
    mars.shape = sf::CircleShape(10.f);
    mars.shape.setFillColor(sf::Color::Red);
    mars.update_pos(2.2790e+11,0);
    mars.mass = 6.4190e+23;
    

    float time = 0;
    float deltaTime = 1;

    while (window.isOpen())
    {
        time = time + deltaTime;
        
        sun.update();
        mercury.update();
        venus.update();
        earth.update();
        mars.update();

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
