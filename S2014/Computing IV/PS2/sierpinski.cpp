#include "sierpinski.hpp"
#include <cmath>

Sierpinski::Sierpinski()
{
    base = Triangle();
    child0 = 0;
    child1 = 0;
    child2 = 0;
}

Sierpinski::Sierpinski(sf::Vector2f Point0,sf::Vector2f Point1,sf::Vector2f Point2)
{
    base = Triangle(Point0,Point1,Point2);
    child0 = 0;
    child1 = 0;
    child2 = 0;
}

Sierpinski::Sierpinski(double Side)
{
    sf::Vector2f p0 = sf::Vector2f(0.5*Side,0);
    sf::Vector2f p1 = sf::Vector2f(0,sqrt(3)/2*Side);
    sf::Vector2f p2 = sf::Vector2f(Side,sqrt(3)/2*Side);
    base = Triangle(p0,p1,p2);
    child0 = 0;
    child1 = 0;
    child2 = 0;
}


Sierpinski::~Sierpinski()
{
    
}

Triangle* Sierpinski::get_base()
{
    return &base;
}

Sierpinski* Sierpinski::get_child0()
{
    return child0;
}

Sierpinski* Sierpinski::get_child1()
{
    return child1;
}

Sierpinski* Sierpinski::get_child2()
{
    return child2;
}

void Sierpinski::create_children()
{
    sf::Vector2f p0 = base.get_p0();
    sf::Vector2f p1 = base.get_p1();
    sf::Vector2f p2 = base.get_p2();

    sf::Vector2f p01 = sf::Vector2f(p1.x + abs(p0.x-p1.x)/2,p0.y + abs(p1.y - p0.y)/2);
    sf::Vector2f p02 = sf::Vector2f(p0.x + abs(p2.x-p0.x)/2,p0.y + abs(p2.y - p0.y)/2);
    sf::Vector2f p12 = sf::Vector2f(p1.x + abs(p2.x-p1.x)/2,p1.y + abs(p2.y - p1.y)/2);

    child0 = new Sierpinski(p0,p01,p02);
    child1 = new Sierpinski(p01,p1,p12);
    child2 = new Sierpinski(p02,p12,p2);

}
