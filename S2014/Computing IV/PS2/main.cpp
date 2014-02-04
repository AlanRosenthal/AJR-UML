#include <SFML/Graphics.hpp>
#include <cmath>
#include "triangle.hpp"
#include "sierpinski.hpp"
#include <iostream>

using namespace std;

void draw_all(sf::RenderWindow *window,Sierpinski *sierpinski);
void recurse(Sierpinski *sierpinski,int depth);

int main(int argc, char* argv[])
{
    if (argc < 3)
    {
        cout << "triangle [recursion depth] [side length]" << endl;
        return -1;
    }
    int depth = atoi(argv[1]);
    int side = atof(argv[2]);

    Sierpinski sierpinski(side);
    recurse(&sierpinski,depth);
    
    sf::RenderWindow window(sf::VideoMode(700,700),"Solar System");
    window.setFramerateLimit(60);
    while(window.isOpen())
    {
        sf::Event event;
        while (window.pollEvent(event))
        {
            if (event.type == sf::Event::Closed)
                window.close();
        }
        window.clear();
        draw_all(&window,&sierpinski);
        window.display();
    }
    return 0;
}
void draw_all(sf::RenderWindow *window,Sierpinski *sierpinski)
{
    if (sierpinski == 0) return;
    Triangle *base = sierpinski->get_base();
    window->draw(*base->get_triangle());
    draw_all(&(*window),sierpinski->get_child0());
    draw_all(&(*window),sierpinski->get_child1());
    draw_all(&(*window),sierpinski->get_child2());
}

void recurse(Sierpinski *sierpinski,int depth)
{
    if (depth == 0) return;
    depth--;
    sierpinski->create_children();
    recurse(sierpinski->get_child0(),depth);
    recurse(sierpinski->get_child1(),depth);
    recurse(sierpinski->get_child2(),depth);
}
