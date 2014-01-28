#ifndef PLANET_HPP
#define PLANET_HPP

#include <iostream>

using namespace std;


class Planet { 
	public:

	//Constructor
	Planet();

	Planet(float, float, float, float, float, string);

	//Destructor
	~Planet();

	//Accessors
	float get_pos_x() const;
	float get_pos_y() const;
	float get_vel_x() const;
	float get_vel_y() const;
	float get_mass() const;
	string get_filename() const;

	//Mutators
	void set_pos_x(float);
	void set_pos_y(float);
	void set_vel_x(float);
	void set_vel_y(float);
	void set_mass(float);
	void set_filename(string);

	private:

	float pos_x;
	float pos_y;
	float vel_x;
	float vel_y;
	float mass;
	string filename;
};

#endif
