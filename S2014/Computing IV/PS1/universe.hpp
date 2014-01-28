#ifndef UNIVERSE_HPP
#define UNIVERSE_HPP

#include <SFML/Graphics.hpp>
#include <iostream>
#include <cmath>
#include "planet.hpp"
#include <vector>

using namespace std;

class Universe {
    public:
    
    //Constructor
    Universe();

    //Destructor
    ~Universe();

    //Accessors
    float get_universe_size() const;
    int get_num_planets() const;
    float get_delta_time() const;
    float get_time() const;

    //Mutator
    void set_universe_size(float);
    void set_num_planets(int);
    void set_delta_time(float);
    void set_time(float);

    //Functions
    void move_planet(Planet p1, Planet p2);
    private:
    
    float universe_size;
    int num_planets;
    float delta_time;
    float time;
    vector<Planet> planets;
};

#endif
