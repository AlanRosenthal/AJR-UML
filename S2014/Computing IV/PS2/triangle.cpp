#include "triangle.hpp"

Triangle::Triangle()
{
    p0 = sf::Vector2f(0,0);
    p1 = sf::Vector2f(0,0);
    p2 = sf::Vector2f(0,0);

    left_triangle = sf::Vector2f(0,0);
    right_triangle = sf::Vector2f(0,0);
    top_triangle = sf::Vector2f(0,0);

    triangle.setPointCount(3);
    triangle.setPoint(0,p0);
    triangle.setPoint(1,p1);
    triangle.setPoint(2,p2);
    triangle.setFillColor(sf::Color::Transparent);
    triangle.setOutlineColor(sf::Color::Yellow);
    triangle.setOutlineThickness(1);
    triangle.setPosition(10,10);
}
Triangle::Triangle(sf::Vector2f Point0,sf::Vector2f Point1,sf::Vector2f Point2)
{
    p0 = Point0;
    p1 = Point1;
    p2 = Point2;

    left_triangle.x = (p2.x - p0.x)/2 + p0.x;
    left_triangle.y = (p2.y - p0.y)/2 + p0.y;

    right_triangle.x = (p1.x - p2.x)/2 + p2.x;
    right_triangle.y = (p2.y - p1.y)/2 + p1.y;

    top_triangle.x = (p1.x - p0.x)/2 + p0.x;
    top_triangle.y = p0.y;

    triangle.setPointCount(3);
    triangle.setPoint(0,p0);
    triangle.setPoint(1,p1);
    triangle.setPoint(2,p2);
    triangle.setFillColor(sf::Color::Transparent);
    triangle.setOutlineColor(sf::Color::Yellow);
    triangle.setOutlineThickness(1);
    triangle.setPosition(10,10);
}

Triangle::~Triangle()
{

}


sf::ConvexShape* Triangle::get_triangle()
{
    return &triangle;
}

/*
int Planet::get_id() const
{
    return id;
}

float Planet::get_pos_x() const
{
    return pos_x;
}

float Planet::get_pos_y() const
{
    return pos_y;
}

float Planet::get_vel_x() const
{
    return vel_x;
}

float Planet::get_vel_y() const
{
    return vel_y;
}

float Planet::get_force_x() const
{
    return force_x;
}

float Planet::get_force_y() const
{
    return force_y;
}

float Planet::get_mass() const
{
    return mass;
}

string Planet::get_filename() const
{
    return filename;
}

sf::Sprite* Planet::get_sprite()
{
    return &sprite;
}

//Mutators
void Planet::set_id(int ID)
{
    id = ID;
}

void Planet::set_pos_x(float PosX)
{
    pos_x = PosX;
}

void Planet::set_pos_y(float PosY)
{
    pos_y = PosY;
}

void Planet::set_vel_x(float VelX)
{
    vel_x = VelX;
}

void Planet::set_vel_y(float VelY)
{
    vel_y = VelY;
}

void Planet::set_force_x(float ForceX)
{
    force_x = ForceX;
}

void Planet::set_force_y(float ForceY)
{
    force_y = ForceY;
}

void Planet::add_to_force_x(float ForceX)
{
    force_x += ForceX;
}

void Planet::add_to_force_y(float ForceY)
{
    force_y += ForceY;
}

void Planet::set_mass(float Mass)
{
    mass = Mass;
}

void Planet::set_filename(string FileName)
{
    filename = FileName;
}

void Planet::set_sprite(sf::Sprite* Sprite)
{
    sprite = *Sprite;
}

*/


