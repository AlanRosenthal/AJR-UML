#include <SFML/Graphics.hpp>
#include <cmath>
#include "triangle.hpp"
#include <iostream>

using namespace std;


void create_triangle_right(sf::ConvexShape* polygon, sf::Vector2f point, double radius);


int main(int argc, char* argv[])
{
    sf::RenderWindow window(sf::VideoMode(500,500),"Solar System");
    window.setFramerateLimit(60);

    Triangle triangle(sf::Vector2f(0,0),sf::Vector2f(400,0),sf::Vector2f(200,0.5*400*sqrt(3)));
    cout << triangle.left_triangle.x << ", " << triangle.left_triangle.y << endl;
    cout << triangle.right_triangle.x << ", " << triangle.right_triangle.y << endl;
    cout << triangle.top_triangle.x << ", " << triangle.top_triangle.y << endl;
    while(window.isOpen())
    {
        sf::Event event;
        while (window.pollEvent(event))
        {
            if (event.type == sf::Event::Closed)
                window.close();
        }
        window.clear();
        window.draw(*triangle.get_triangle());
        window.display();
    }
    return 0;
}

void create_triangle_right(sf::ConvexShape* polygon, sf::Vector2f point, double radius)
{
    double x = 0;
    double y = 0;//point.y;
    polygon->setPointCount(3);
    polygon->setPoint(0,point);
    polygon->setPoint(1,sf::Vector2f(x+radius,y));
    polygon->setPoint(2,sf::Vector2f(x+radius/2,y+0.5*radius*sqrt(3)));
    polygon->setFillColor(sf::Color::Black);
    polygon->setOutlineColor(sf::Color::Yellow);
    polygon->setOutlineThickness(1);
    polygon->setPosition(10, 10); 
}

