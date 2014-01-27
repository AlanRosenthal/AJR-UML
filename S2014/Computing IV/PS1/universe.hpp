#include <SFML/Graphics.hpp>
#include <iostream>
#include <math.h>

using namespace std;

class Universe {

    public:
    float universe_size;
    int num_planets;
    float delta_time;
    float time;

    class Planet { 
        public:

        float pos_x;
        float pos_y;
        float vel_x;
        float vel_y;
        float mass;
        string filename;
        sf::CircleShape shape;

        void update(void)
        {
            float km_per_pixel = 2e9;
            shape.setPosition(pos_x/km_per_pixel+250-shape.getRadius(),pos_y/km_per_pixel+250-shape.getRadius());
        };

    };

    void move_planet(Planet p1, Planet p2)
    {
        static float G = 6.67e-11;
        float delta_x = p2.pos_x - p1.pos_x;
        float delta_y = p2.pos_y - p1.pos_y;
        float r = sqrt(pow(delta_x,2)+pow(delta_y,2));
        float F = G*p1.mass*p2.mass/(pow(r,2));
        float Fx = F*delta_x/r;
        float Fy = F*delta_y/r;
        float ax = Fx/p1.mass;
        float ay = Fy/p1.mass;
        p1.vel_x = p1.vel_x + delta_time*ax;
        p1.vel_y = p1.vel_y + delta_time*ay;
        p1.pos_x = p1.pos_x + delta_time*p1.vel_x;
        p1.pos_y = p1.pos_y + delta_time*p1.vel_y;
    }

};
