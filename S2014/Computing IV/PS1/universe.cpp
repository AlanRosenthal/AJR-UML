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
    static float G = 6.67e-11;
    float m1 = p1->get_mass();
    float m2 = p2->get_mass();
    float delta_x = p2->get_pos_x() - p1->get_pos_x();
    float delta_y = p2->get_pos_y() - p1->get_pos_y();
    float r = sqrt(pow(delta_x,2) + pow(delta_y,2));
    float F = (G*m1)*(m2/pow(r,2));
    float Fx = (F*delta_x)/r;
    float Fy = (F*delta_y)/r;
    p1->add_to_force_x(Fx);
    p1->add_to_force_y(Fy);
    /*
    
    
    float ax = Fx/m1;
    float ay = Fy/m1;
    float dvx = delta_time*ax;
    float dvy = delta_time*ay;
    cout << "id1: " << p1->get_id() << endl;
    cout << "id2: " << p2->get_id() << endl;
    cout << "m1: " << m1 << endl;
    cout << "m2: " << m2 << endl;
    cout << "delta_x: " << delta_x << endl;
    cout << "delta_y: " << delta_y << endl;
    cout << "r: " << r << endl;
    cout << "F: " << F << endl;
    cout << "Fx: " << Fx << endl;
    cout << "Fy: " << Fy << endl;
    cout << "ax: " << ax << endl;
    cout << "ay: " << ay << endl;
    
    p1->add_new_vel_x(dvx);
    p1->add_new_vel_y(dvy);
    p1->add_new_pos_x(delta_time*(p1->get_vel_x() + dvx));
    p1->add_new_pos_y(delta_time*(p1->get_vel_y() + dvy));
    //cout << p1->get_id() << ": " << Fx << ", " << Fy << "; " << p1->get_new_pos_x() << ", " << p1->get_new_pos_y() << "; " << p1->get_new_vel_x() << ", " << p1->get_new_vel_y() << endl;
    */
}

void Universe::move_all_planets()
{
    //set forces to 0
    for (vector<Planet>::iterator i = planets.begin(); i != planets.end(); ++i)
    {
        i->set_force_x(0.0);
        i->set_force_y(0.0);
/*
        i->set_new_pos_x(0);
        i->set_new_pos_y(0);
        i->set_new_vel_x(0);
        i->set_new_vel_y(0);
*/
    }
    //calculate superposition forces
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
    //apply superpositions
    for (vector<Planet>::iterator i = planets.begin(); i != planets.end(); ++i)
    {
        float ax = (i->get_force_x()) / (i->get_mass());
        float ay = (i->get_force_y()) / (i->get_mass());
        float vx = (i->get_vel_x()) + delta_time*ax;
        float vy = (i->get_vel_y()) + delta_time*ay;
        i->set_vel_x(vx);
        i->set_vel_y(vy);
        float px = (i->get_pos_x()) + delta_time*vx;
        float py = (i->get_pos_y()) + delta_time*vy;
        i->set_pos_x(px);
        i->set_pos_y(py);
/*        i->add_pos_x(i->get_new_pos_x());
        i->add_pos_y(i->get_new_pos_y());
        i->add_vel_x(i->get_new_vel_x());
        i->add_vel_y(i->get_new_vel_y());*/
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
    sf::Vector2u tex_size = tex.getSize();
    
    float x = ((window_size.x / (universe_size*2)) * p->get_pos_x()) + window_size.x/2 - tex_size.x/2;
    float y = ((window_size.y / (universe_size*2)) * p->get_pos_y()) + window_size.y/2 - tex_size.y/2;
    s->setPosition(x,y);
    window->draw(*s);
}
void Universe::draw_all_planets(sf::RenderWindow *window)
{
    for (vector<Planet>::iterator i = planets.begin(); i != planets.end(); ++i)
    {
        draw_planet(&(*window),&(*i));
    }
}

