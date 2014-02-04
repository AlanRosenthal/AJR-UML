#ifndef TRIANGLE_HPP
#define TRIANGLE_HPP

#include <SFML/Graphics.hpp>

class Triangle { 
    public:

    //Constructor
    Triangle();
    Triangle(sf::Vector2f,sf::Vector2f,sf::Vector2f);

    //Destructor
    ~Triangle();

    //Accessors
    sf::ConvexShape* get_triangle();

    //Mutators


//    private:

    
    sf::Vector2f left_triangle;
    sf::Vector2f right_triangle;
    sf::Vector2f top_triangle;
    double radius;
    sf::ConvexShape triangle;
    sf::Vector2f p0;
    sf::Vector2f p1;
    sf::Vector2f p2;
};

#endif
