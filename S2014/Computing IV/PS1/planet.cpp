#include "planet.hpp"

Planet::Planet()
{
    pos_x = 0.0;
    pos_y = 0.0;
    vel_x = 0.0;
    vel_y = 0.0;
    mass = 0.0;
}

Planet::Planet(float PosX, float PosY, float VelX, float VelY, float Mass, string FileName)
{
    pos_x = PosX;
    pos_y = PosY;
    vel_x = VelX;
    vel_y = VelY;
    mass = Mass;
    filename = FileName;
}

Planet::~Planet()
{

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

float Planet::get_mass() const
{
    return mass;
}

string Planet::get_filename() const
{
    return filename;
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
void Planet::set_mass(float Mass)
{
    mass = Mass;
}

void Planet::set_filename(string FileName)
{
    filename = FileName;
}

