#ifndef CODEJAM_H
#define CODEJAM_H

//struct to contain the inputs
struct input_t
{
    int id;
    int R;
    int C;
    int M;
    char * output;
};

//Fuction prototypes
void * read_input_file(char * file, int * total);
void solution(struct input_t * input);
void write_output_file(char * file,struct input_t ** input,int total);

#endif