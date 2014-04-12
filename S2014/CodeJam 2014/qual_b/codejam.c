#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include "codejam.h"

int main(int argc, char * argv[])
{
    int i;
    int total;
    struct input_t ** input;
    
    if (argc != 3)
    {
        printf("./codejam inputfile outputfile\n");
        return -1;
    }
    
    //read in file
    input = read_input_file(argv[1],&total);
    
    //solve
    for (i = 0;i < total;i++)
    {
        solution(input[i]);
    }
    
    //write output file
    write_output_file(argv[2],input,total);

    return 1;
}

//mallocs space and reads the input file
void * read_input_file(char * file,int * total)
{
    int i,j;
    FILE * fp;
    struct input_t **input;
    fp = fopen(file,"r");
    if (fp == NULL)
    {
        perror("Unable to open file ");
        exit(1);
    }
    fscanf(fp,"%d",total);
    input = malloc(*total * sizeof(struct input_t));
    for (i = 0;i < *total;i++)
    {
        input[i] = malloc(sizeof(struct input_t));
    }
    for (i = 0;i < *total;i++)
    {
        input[i]->id = i+1;
        fscanf(fp,"%lf %lf %lf\n",&(input[i]->C),&(input[i]->F),&(input[i]->X));
    }
    fclose(fp);
    return input;
}

//writes the output file
void write_output_file(char * file,struct input_t ** input,int total)
{
    int i;
    FILE * fp;
    fp = fopen(file,"w");
    if (fp == NULL)
    {
        perror("Unable to open file ");
        exit(1);
    }
    for (i = 0;i < total; i++)
    {
        fprintf(fp,"Case #%d: %s\n",input[i]->id,input[i]->output);
    }
    fclose(fp);
}

//called by main for each instace of a struct
void solution(struct input_t * input)
{
    double time = 0.0;
    double cps = 2.0;
    double new_factory_time = 0.0;
    double winning_time = DBL_MAX; //time until you win
    //continue calcuating the time until the winning_time hits a minimum, then use that value
    while (1)
    {
        if (winning_time < (time + (input->X / cps))) //local minumum, break
            break;
        new_factory_time = input->C / cps;
        winning_time = time + (input->X / cps);
        time += new_factory_time;
        cps += input->F;
    }
    sprintf(input->output,"%lf",winning_time);
}
