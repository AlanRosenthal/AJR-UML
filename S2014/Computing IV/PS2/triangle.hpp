#ifndef TRIANGLE_HPP
#define TRIANGLE_HPP

#include <SFML/Graphics.hpp>

class Triangle : public sf::Drawable
{ 
    public:

    //Constructor
    Triangle();
    Triangle(sf::Vector2f,sf::Vector2f,sf::Vector2f);

    //Destructor
    ~Triangle();

    //Accessors
    sf::Vector2f get_p0() const;
    sf::Vector2f get_p1() const;
    sf::Vector2f get_p2() const;

    //Mutators

    //Overloaded Function
    void draw(sf::RenderTarget& target, sf::RenderStates states) const;

    private:
    
    sf::ConvexShape triangle;
    sf::Vector2f p0;
    sf::Vector2f p1;
    sf::Vector2f p2;
};



#endif
