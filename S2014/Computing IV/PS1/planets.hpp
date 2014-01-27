#include <SFML/Graphics.hpp>
#include <iostream>

using namespace std;


class Planet { 
    float pos_x;
    float pos_y;
    float vel_x;
    float vel_y;

    public:

    float mass;
    sf::CircleShape shape;

    void update_pos(float new_x, float new_y)
    {
        pos_x = new_x;
        pos_y = new_y;
//      shape.setPosition(new_x,new_y);
    };

    void update(void)
    {
        float km_per_pixel = 2e9;
        shape.setPosition(pos_x/km_per_pixel+250-shape.getRadius(),pos_y/km_per_pixel+250-shape.getRadius());
    };

};
