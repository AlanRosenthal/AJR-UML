#include "universe.hpp"

//Constructors
Universe::Universe()
{
    universe_size = 0.0;
    num_planets = 0;
    delta_time = 0;
    time = 0;
}

Universe::~Universe()
{

}

//Accessors
float Universe::get_universe_size() const
{
    return universe_size;
}

int Universe::get_num_planets() const
{
    return num_planets;
}

float Universe::get_delta_time() const
{
    return delta_time;
}

float Universe::get_time() const
{
    return time;
}

//Mutators
void Universe::set_universe_size(float UniverseSize)
{
    universe_size = UniverseSize;
}

void Universe::set_num_planets(int NumPlanets)
{
    num_planets = NumPlanets;
}

void Universe::set_delta_time(float DeltaTime)
{
    delta_time = DeltaTime;
}

void Universe::set_time(float Time)
{
    time = Time;
}

void Universe::add_planets(Planet new_planet)
{
    planets.push_back(new_planet);
}
void Universe::move_all_planets()
{
    for (vector<Planet>::iterator i = planets.begin(); i != planets.end(); ++i)
    {
        cout << i->get_filename() << endl;
    }

}




//Member Functions
void Universe::move_planet(Planet p1, Planet p2)
{
    static float G = 6.67e-11;
    float delta_x = p2.get_pos_x() - p1.get_pos_x();
    float delta_y = p2.get_pos_y() - p1.get_pos_y();
    float r = sqrt(pow(delta_x,2)+pow(delta_y,2));
    float F = G*(p1.get_mass()*p2.get_mass())/(pow(r,2));
    float Fx = F*delta_x/r;
    float Fy = F*delta_y/r;
    float ax = Fx/p1.get_mass();
    float ay = Fy/p1.get_mass();
    p1.set_vel_x(p1.get_vel_x() + delta_time*ax);
    p1.set_vel_y(p1.get_vel_y() + delta_time*ay);
    p1.set_pos_x(p1.get_pos_x() + delta_time*p1.get_vel_x());
    p1.set_pos_y(p1.get_pos_y() + delta_time*p1.get_vel_y());
}

