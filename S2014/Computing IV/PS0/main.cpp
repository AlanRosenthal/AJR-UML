#include <SFML/Graphics.hpp>

int main()
{
    sf::RenderWindow window(sf::VideoMode(400, 600), "SFML works!");
    sf::CircleShape shape(100.f);
    shape.setFillColor(sf::Color::Green);
    window.setFramerateLimit(60);
    int dir_x = 1;
    int dir_y = 1;
    float speed_x = 1;
    float speed_y = 1; 
    while (window.isOpen())
    {
        sf::Event event;
        while (window.pollEvent(event))
        {
            if (event.type == sf::Event::Closed)
                window.close();
        }
    	shape.move(speed_x*dir_x, speed_y*dir_y);
        sf::Vector2f pos = shape.getPosition();
        if ((pos.x >= 200) && (dir_x == 1))
        {
            speed_x = speed_x * 1.25;
            dir_x = -1;
            if (speed_x > 20) speed_x = 20;
        }
        if ((pos.x <= 0) && (dir_x == -1))
        {
            speed_x = speed_x * 1.25;
            dir_x = 1;
            if (speed_x > 20) speed_x = 20;
        }
        if ((pos.y >= 400) && (dir_y == 1))
        {
             speed_y = speed_y * 1.25;
             dir_y = -1;
             if (speed_y > 20) speed_y = 20;
        }   
        if ((pos.y <= 0) && (dir_y == -1))
        {
            speed_y = speed_y * 1.25;
            dir_y = 1;
            if (speed_y > 20) speed_y = 20;
        }
        window.clear();
        window.draw(shape);
        window.display();
    }
    return 0;
}
