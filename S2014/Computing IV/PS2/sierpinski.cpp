#include "sierpinski.hpp"
#include <cmath>

Sierpinski::Sierpinski()
{
    base = Triangle();
    child0 = 0;
    child1 = 0;
    child2 = 0;
}

Sierpinski::Sierpinski(sf::Vector2f Point0,sf::Vector2f Point1,sf::Vector2f Point2,int Depth)
{
    base = Triangle(Point0,Point1,Point2);
    child0 = 0;
    child1 = 0;
    child2 = 0;
    if (Depth == 0) return;
    Depth--;
    sf::Vector2f p0 = Point0;
    sf::Vector2f p1 = Point1;
    sf::Vector2f p2 = Point2;
    sf::Vector2f p01 = sf::Vector2f(p1.x + abs(p0.x-p1.x)/2,p0.y + abs(p1.y - p0.y)/2);
    sf::Vector2f p02 = sf::Vector2f(p0.x + abs(p2.x-p0.x)/2,p0.y + abs(p2.y - p0.y)/2);
    sf::Vector2f p12 = sf::Vector2f(p1.x + abs(p2.x-p1.x)/2,p1.y + abs(p2.y - p1.y)/2);
    child0 = new Sierpinski(p0,p01,p02,Depth);
    child1 = new Sierpinski(p01,p1,p12,Depth);
    child2 = new Sierpinski(p02,p12,p2,Depth);
}

Sierpinski::Sierpinski(double Side, int Depth)
{
    sf::Vector2f p0 = sf::Vector2f(0.5*Side,0);
    sf::Vector2f p1 = sf::Vector2f(0,sqrt(3)/2*Side);
    sf::Vector2f p2 = sf::Vector2f(Side,sqrt(3)/2*Side);
    *this = Sierpinski(p0,p1,p2,Depth);
}

Sierpinski::~Sierpinski()
{
    
}

void Sierpinski::draw(sf::RenderTarget& target, sf::RenderStates states) const
{
    target.draw(base);
    if (child0 == 0) return;
    target.draw(*child0);
    target.draw(*child1);
    target.draw(*child2);
}

