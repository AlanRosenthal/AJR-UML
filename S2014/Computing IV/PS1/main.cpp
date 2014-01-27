#include <SFML/Graphics.hpp>
#include "planets.hpp"
#include <iostream>

using namespace std;

int main()
{
    float G = 6.67e-11;
    cout << "STARTING\n";
    sf::RenderWindow window(sf::VideoMode(500, 500), "Solar System");
    window.setFramerateLimit(60);

    Planet sun, earth;

    sun.shape = sf::CircleShape(20.f);
    sun.shape.setFillColor(sf::Color::Yellow);
    sun.update_pos(0,0);
    sun.mass= 1.9890e+30;
    
    earth.shape = sf::CircleShape(10.f);
    earth.shape.setFillColor(sf::Color::Blue);
    earth.update_pos(1.4960e+11,0);
    earth.mass = 5.9740e+24;
    

    float time = 0;
    float deltaTime = 1;

    while (window.isOpen())
    {
        time = time + deltaTime;
        sun.update();
        earth.update();

        sf::Vector2f pos;
        pos  = sun.shape.getPosition();
        cout << "sun position: " << pos.x << ", " << pos.y << "\n";
        pos = earth.shape.getPosition();
        cout << "ear position: " << pos.x << ", " << pos.y << "\n";


        sf::Event event;
        while (window.pollEvent(event))
        {
            if (event.type == sf::Event::Closed)
                window.close();
        }
        window.clear();

        window.draw(sun.shape);
        window.draw(earth.shape);

        window.display();
    }
    return 0;
}
