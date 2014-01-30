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

void Universe::push_planets(Planet new_planet)
{
    planets.push_back(new_planet);
}

//Member Functions
void Universe::move_planet(Planet *p1, Planet *p2)
{
    /*
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
    */
    cout << "Planet " << p1->get_id() << " ->  " << p2->get_id() << ": " << endl;
    float px = p1->get_pos_x();
    float py = p1->get_pos_y();
    float vx = p1->get_vel_x();
    float vy = p1->get_vel_y();


    static float G = 6.67e-11;
    float m1 = p1->get_mass();
    float m2 = p2->get_mass();
    float delta_x = p2->get_pos_x() - p1->get_pos_x();
    float delta_y = p2->get_pos_y() - p1->get_pos_y();
    float r = sqrt(pow(delta_x,2) + pow(delta_y,2));
    float F = (G*m1)*(m2/pow(r,2));
    float Fx = (F*delta_x)/r;
    float Fy = (F*delta_y)/r;
    float ax = Fx/m1;
    float ay = Fy/m1;
    cout << "delta_x: " << delta_x << ", delta_y: " << delta_y << ", F: " << F << ", Fx: " << Fx << ", Fy: " << Fy << endl;
        
    p1->set_vel_x(p1->get_vel_x() + delta_time*ax);
    p1->set_vel_y(p1->get_vel_y() + delta_time*ay);
    p1->set_pos_x(p1->get_pos_x() + delta_time*p1->get_vel_x());
    p1->set_pos_y(p1->get_pos_y() + delta_time*p1->get_vel_y());

    float dpx = (p1->get_pos_x()) - px;
    float dpy = (p1->get_pos_y()) - py;
    float dvx = (p1->get_vel_x()) - vx;
    float dvy = (p1->get_vel_y()) - vy;
    cout << "dpx: " << dpx << ", dpy: " << dpy << ", dvx: " << dvx << ", dvy: " << dvy << endl;
}

void Universe::move_all_planets()
{
    for (vector<Planet>::iterator i = planets.begin(); i != planets.end(); ++i)
    {
        for (vector<Planet>::iterator j = planets.begin(); j != planets.end(); ++j)
        {
            if (i->get_id() == j->get_id())
            {
                continue;
            }
            move_planet(&(*i),&(*j));
        }
    }
    time = time + delta_time;
}

void Universe::draw_planet(sf::RenderWindow *window,Planet *p)
{
    sf::Sprite *s = p->get_sprite();
    sf::Texture tex;
    tex.loadFromFile(p->get_filename());
    s->setTexture(tex);
    sf::Vector2u window_size = window->getSize();
    float x = ((window_size.x / (universe_size*2)) * p->get_pos_x()*.25) + window_size.x/2;
    float y = ((window_size.y / (universe_size*2)) * p->get_pos_y()*.25) + window_size.y/2;
    s->setPosition(x,y);
    //cout << p->get_filename() << ": x: " << x << ", y: " << y << endl;
    window->draw(*s);
}
void Universe::draw_all_planets(sf::RenderWindow *window)
{
    for (vector<Planet>::iterator i = planets.begin(); i != planets.end(); ++i)
    {
        draw_planet(&(*window),&(*i));
    }
}

