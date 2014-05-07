#ifndef CODEJAM_H
#define CODEJAM_H

//use garbage collection malloc
#define malloc GC_malloc
#define free GC_free

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

//marcos
#define printf_int1(a) printf("%s: %d\n",#a,a);
#define printf_int2(a,b) printf("%s: %d, %s: %d\n",#a,a,#b,b);
#define printf_int3(a,b,c) printf("%s: %d, %s: %d, %s: %d\n",#a,a,#b,b,#c,c);
#define printf_int4(a,b,c,d) printf("%s: %d, %s: %d, %s: %d, %s: %d\n",#a,a,#b,b,#c,c,#d,d);


#endif