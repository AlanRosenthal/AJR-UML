#include "triangle.hpp"

Triangle::Triangle()
{
    p0 = sf::Vector2f(0,0);
    p1 = sf::Vector2f(0,0);
    p2 = sf::Vector2f(0,0);
    triangle.setPointCount(3);
    triangle.setPoint(0,p0);
    triangle.setPoint(1,p1);
    triangle.setPoint(2,p2);
    triangle.setFillColor(sf::Color::Transparent);
    triangle.setOutlineColor(sf::Color::Yellow);
    triangle.setOutlineThickness(1);
    triangle.setPosition(0,0);
}
Triangle::Triangle(sf::Vector2f Point0,sf::Vector2f Point1,sf::Vector2f Point2)
{
    p0 = Point0;
    p1 = Point1;
    p2 = Point2;
    triangle.setPointCount(3);
    triangle.setPoint(0,p0);
    triangle.setPoint(1,p1);
    triangle.setPoint(2,p2);
    triangle.setFillColor(sf::Color::Transparent);
    triangle.setOutlineColor(sf::Color::Yellow);
    triangle.setOutlineThickness(1);
    triangle.setPosition(0,0);
}

Triangle::~Triangle()
{

}

sf::ConvexShape* Triangle::get_triangle()
{
    return &triangle;
}

sf::Vector2f Triangle::get_p0() const
{
    return p0;
}

sf::Vector2f Triangle::get_p1() const
{
    return p1;
}

sf::Vector2f Triangle::get_p2() const
{
    return p2;
}

