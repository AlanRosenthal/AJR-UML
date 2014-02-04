#ifndef SIERPINSKI_HPP
#define SIERPINSKI_HPP

#include "triangle.hpp"
#include <SFML/Graphics.hpp>

class Sierpinski {
    public:

    //Constructor
    Sierpinski();
    Sierpinski(sf::Vector2f,sf::Vector2f,sf::Vector2f);
    Sierpinski(double); 

    //Destructor
    ~Sierpinski();

    //Accessors
    Triangle* get_base();
    Sierpinski* get_child0();
    Sierpinski* get_child1();
    Sierpinski* get_child2();

    //Mutators
    void create_children();

    private:
    Triangle base;
    Sierpinski* child0;
    Sierpinski* child1;
    Sierpinski* child2;
};

#endif

