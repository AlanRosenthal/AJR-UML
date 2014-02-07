#include "rosenthal.hpp"
#include <cmath>
#include <SFML/System/Vector2.hpp>

Rosenthal::Rosenthal()
{
    base = Parallelogram();
    filled0 = 0;
    filled1 = 0;
    filled2 = 0;
    filled3 = 0;
    child0 = 0;
}

Rosenthal::Rosenthal(sf::Vector2f Point0,sf::Vector2f Point1,sf::Vector2f Point2,sf::Vector2f Point3,int DepthA, int DepthB, float percent)
{
    base = Parallelogram(Point0,Point1,Point2,Point3,sf::Color::Transparent);
    filled0 = 0;
    filled1 = 0;
    filled2 = 0;
    filled3 = 0;
    child0 = 0;
    if (DepthA <= 0) return;
    DepthA--;
    DepthB--;
    sf::Vector2f p0 = Point0;
    sf::Vector2f p1 = Point1;
    sf::Vector2f p2 = Point2;
    sf::Vector2f p3 = Point3;
    sf::Vector2f p30 = (p3 * (1-percent)) + (p0 * percent); 
    sf::Vector2f p23 = (p2 * (1-percent)) + (p3 * percent);
    sf::Vector2f p12 = (p1 * (1-percent)) + (p2 * percent);
    sf::Vector2f p01 = (p0 * (1-percent)) + (p1 * percent);
    child0 = new Rosenthal(p30,p23,p12,p01,DepthA,DepthB,percent*0.75);
    filled0 = new Sierpinski(p01,p0,p30,DepthB);
    filled1 = new Sierpinski(p30,p3,p23,DepthB);
    filled2 = new Sierpinski(p23,p2,p12,DepthB);
    filled3 = new Sierpinski(p12,p1,p01,DepthB);
}

Rosenthal::Rosenthal(double Width, double Height, int DepthA, int DepthB, float percent)
{
    sf::Vector2f p0 = sf::Vector2f(0,0);
    sf::Vector2f p1 = sf::Vector2f(0,Height);
    sf::Vector2f p2 = sf::Vector2f(Width,Height);
    sf::Vector2f p3 = sf::Vector2f(Width,0);
    *this = Rosenthal(p0,p1,p2,p3,DepthA,DepthB,percent);
}

Rosenthal::~Rosenthal()
{
    
}

void Rosenthal::draw(sf::RenderTarget& target, sf::RenderStates states) const
{
    if (filled0 != 0) target.draw(*filled0);
    if (filled1 != 0) target.draw(*filled1);
    if (filled2 != 0) target.draw(*filled2);
    if (filled3 != 0) target.draw(*filled3);
    if (child0 != 0) target.draw(*child0);
    target.draw(base);
}

