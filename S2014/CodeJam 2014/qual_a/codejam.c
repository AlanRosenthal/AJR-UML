#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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
        fscanf(fp,"%d\n",&(input[i]->row1));
        for (j = 0;j < 16; j++)
        {
            fscanf(fp,"%d",&(input[i]->deck1[j]));
        }
        fscanf(fp,"%d\n",&(input[i]->row2));
        for (j = 0;j < 16; j++)
        {
            fscanf(fp,"%d",&(input[i]->deck2[j]));
        }
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
    int i;
    int row1[4];
    int row2[4];
    int match;
    //picks the selected row out of the array of all cards
    for (i = 0;i < 4;i++)
    {
        row1[i] = input->deck1[(input->row1-1)*4+i];
        row2[i] = input->deck2[(input->row2-1)*4+i];
    }
    //calculates the number of common values between each row and sets the output
    switch (common(row1,row2,4,&match))
    {
        case 0:
            sprintf(input->output,"Volunteer cheated!",input->id);
            break;
        case 1:
            sprintf(input->output,"%d",match);
            break;
        case 2:
        case 3:
        case 4:
            sprintf(input->output,"Bad magician!");
            break;
    }
}

//returns the number of common matches between two arrays of the same length
//if there is one match, it sets the sets *match to the value
//if there is more than one match, it sets *match to the last match
int common(int array1[],int array2[],int length,int * match)
{
    int i,j;
    int count = 0;
    for (i = 0;i < length;i++)
    {
        for (j = 0;j < length;j++)
        {
            if (array1[i] == array2[j])
            {
                count++;
                * match = array1[i];
            }
        }
    }
    return count;
}
