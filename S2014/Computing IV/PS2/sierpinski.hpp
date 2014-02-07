#ifndef SIERPINSKI_HPP
#define SIERPINSKI_HPP

#include "triangle.hpp"
#include <SFML/Graphics.hpp>

class Sierpinski : public sf::Drawable
{
    public:

    //Constructor
    Sierpinski();
    Sierpinski(sf::Vector2f,sf::Vector2f,sf::Vector2f,int);
    Sierpinski(double,int); 

    //Destructor
    ~Sierpinski();

    //Accessors

    //Mutators

    //Overloaded Functions
    void draw(sf::RenderTarget& target, sf::RenderStates states) const;

    private:
    Triangle base;
    Triangle* filled;
    Sierpinski* child0;
    Sierpinski* child1;
    Sierpinski* child2;
};

#endif

