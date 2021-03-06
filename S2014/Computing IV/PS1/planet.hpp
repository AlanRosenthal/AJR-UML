#ifndef PLANET_HPP
#define PLANET_HPP

#include <SFML/Graphics.hpp>

using namespace std;

class Planet { 
    public:

    //Constructor
    Planet();

    Planet(int, float, float, float, float, float, string);

    //Destructor
    ~Planet();

    //Accessors
    int get_id() const;
    float get_pos_x() const;
    float get_pos_y() const;
    float get_vel_x() const;
    float get_vel_y() const;
    float get_force_x() const;
    float get_force_y() const;
    float get_mass() const;
    string get_filename() const;
    sf::Sprite* get_sprite();

    //Mutators
    void set_id(int);
    void set_pos_x(float);
    void set_pos_y(float);
    void set_vel_x(float);
    void set_vel_y(float);
    void set_force_x(float);
    void set_force_y(float);
    void add_to_force_x(float);
    void add_to_force_y(float);
    void set_mass(float);
    void set_filename(string);
    void set_sprite(sf::Sprite*);

    private:
    
    int id;
    float pos_x;
    float pos_y;
    float vel_x;
    float vel_y;
    float new_pos_x;
    float new_pos_y;
    float new_vel_x;
    float new_vel_y;
    float force_x;
    float force_y;
    float mass;
    string filename;
    sf::Sprite sprite;
};

#endif
