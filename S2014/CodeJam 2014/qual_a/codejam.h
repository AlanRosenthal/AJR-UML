#ifndef CODEJAM_H
#define CODEJAM_H

//struct to contain the inputs
struct input_t
{
    int id;
    int row1;
    int row2;
    int deck1[16];
    int deck2[16];
    char output[100];
};

//Fuction prototypes
void * read_input_file(char * file, int * total);
void solution(struct input_t * input);
void write_output_file(char * file,struct input_t ** input,int total);
int common(int array1[],int array2[],int length,int * match);


#endif