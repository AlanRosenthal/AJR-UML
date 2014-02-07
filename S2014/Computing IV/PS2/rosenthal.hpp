#ifndef ROSENTHAL_HPP
#define ROSENTHAL_HPP

#include "sierpinski.hpp"
#include "parallelogram.hpp"
#include <SFML/Graphics.hpp>

class Rosenthal : public sf::Drawable
{
    public:

    //Constructor
    Rosenthal();
    Rosenthal(sf::Vector2f,sf::Vector2f,sf::Vector2f,sf::Vector2f,int,int,float);
    Rosenthal(double,double,int,int,float); 

    //Destructor
    ~Rosenthal();

    //Accessors

    //Mutators

    //Overloaded Functions
    void draw(sf::RenderTarget& target, sf::RenderStates states) const;

    private:
    Parallelogram base;
    Sierpinski* filled0;
    Sierpinski* filled1;
    Sierpinski* filled2;
    Sierpinski* filled3;
    Rosenthal* child0;
};

#endif

