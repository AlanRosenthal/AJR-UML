#ifndef PARALLELOGRAM_HPP
#define PARALLELOGRAM_HPP

#include <SFML/Graphics.hpp>

class Parallelogram : public sf::Drawable
{ 
    public:

    //Constructor
    Parallelogram();
    Parallelogram(sf::Vector2f,sf::Vector2f,sf::Vector2f,sf::Vector2f,sf::Color);

    //Destructor
    ~Parallelogram();

    //Accessors
    sf::Vector2f get_p0() const;
    sf::Vector2f get_p1() const;
    sf::Vector2f get_p2() const;
    sf::Vector2f get_p3() const;

    //Mutators

    //Overloaded Function
    void draw(sf::RenderTarget& target, sf::RenderStates states) const;

    private:
    
    sf::ConvexShape parallelogram;
    sf::Vector2f p0;
    sf::Vector2f p1;
    sf::Vector2f p2;
    sf::Vector2f p3;
};



#endif
