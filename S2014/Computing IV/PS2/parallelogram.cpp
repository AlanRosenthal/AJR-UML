#include "parallelogram.hpp"

Parallelogram::Parallelogram()
{
    p0 = sf::Vector2f(0,0);
    p1 = sf::Vector2f(0,0);
    p2 = sf::Vector2f(0,0);
    p3 = sf::Vector2f(0,0);
    parallelogram.setPointCount(4);
    parallelogram.setPoint(0,p0);
    parallelogram.setPoint(1,p1);
    parallelogram.setPoint(2,p2);
    parallelogram.setPoint(3,p3);
    parallelogram.setFillColor(sf::Color::Transparent);
    parallelogram.setOutlineColor(sf::Color::Yellow);
    parallelogram.setOutlineThickness(-1);
    parallelogram.setPosition(0,0);
}

Parallelogram::Parallelogram(sf::Vector2f Point0,sf::Vector2f Point1,sf::Vector2f Point2,sf::Vector2f Point3,sf::Color FillColor)
{
    p0 = Point0;
    p1 = Point1;
    p2 = Point2;
    p3 = Point3;
    parallelogram.setPointCount(4);
    parallelogram.setPoint(0,p0);
    parallelogram.setPoint(1,p1);
    parallelogram.setPoint(2,p2);
    parallelogram.setPoint(3,p3);
    parallelogram.setFillColor(FillColor);
    parallelogram.setOutlineColor(sf::Color::Yellow);
    parallelogram.setOutlineThickness(-1);
    parallelogram.setPosition(0,0);
}

Parallelogram::~Parallelogram()
{

}

sf::Vector2f Parallelogram::get_p0() const
{
    return p0;
}

sf::Vector2f Parallelogram::get_p1() const
{
    return p1;
}

sf::Vector2f Parallelogram::get_p2() const
{
    return p2;
}

sf::Vector2f Parallelogram::get_p3() const
{
    return p3;
}

void Parallelogram::draw(sf::RenderTarget& target, sf::RenderStates states) const
{
    target.draw(parallelogram);
}

