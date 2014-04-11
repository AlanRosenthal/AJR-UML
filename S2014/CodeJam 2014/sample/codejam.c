#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "codejam.h"

void * read_input_file(char * file, int * total);
void solution(struct input_t * input);
void write_output_file(char * file,struct input_t ** input,int total);

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

void * read_input_file(char * file,int * total)
{
    int i;
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
        fscanf(fp,"%s\n",input[i]->line1);
        fscanf(fp,"%s\n",input[i]->line2);
        fscanf(fp,"%s\n",input[i]->line3);
        fscanf(fp,"%s\n",input[i]->line4);
    }
    fclose(fp);
    return input;
}

void solution(struct input_t * input)
{
    sprintf(input->output,"Case #%d: X won",input->id);
}

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
        fprintf(fp,"%s\n",input[i]->output);
    }
    fclose(fp);
    
    
}