#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include "codejam.h"
void draw_mines(char minesweeper[],int row,int col,int mines);
void print_mines(char minesweeper[],int row,int col);
int max(int a, int b);
int min(int a, int b);

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
        fscanf(fp,"%d %d %d\n",&(input[i]->R),&(input[i]->C),&(input[i]->M));
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

//called by main for each instace of a  struct
void solution(struct input_t * input)
{
    int i;
    int pos = 0;
    int dir = 2; //1: right, 2: down, 3: right, 4: up
    char * minesweeper = malloc(sizeof(char)*input->R*input->C);
    //malloc the size of output since it can be very large
    draw_mines(minesweeper,input->R,input->C,input->M);
    print_mines(minesweeper,input->R,input->C);
    //free(minesweeper);
    //input->output = malloc(sizeof(char)*10);
    //sprintf(input->output,"test %d",input->id);
    //input->output = malloc(sizeof(char)*input->R*input->C+input->R);
}
void draw_mines(char minesweeper[],int row,int col,int mines)
{
    int i,j;
    int no_mines = row*col-mines;
    for (i = 0;i < row;i++)
    {
        for (j = 0;j < col;j++)
        {
            minesweeper[i*col+j] = 48;
        }
    }
    printf("r: %d, c:%d, m:%d\n",row,col,mines);
    
    //for (PENIS = PENIS; PENIS > PENIS; PENIS ++)
//     for (i = 0;i < max(row,col);i++)
//     {
//         for (j = 0;j < i;j++)
//         {
//             if ((i < col) && (j < row))
//             {
//                 if (no_mines-- > 0)
//                     minesweeper[j*col+i] = '.';
//                 else
//                     minesweeper[j*col+i] = '*';
//             }
//             if ((j < col) && (i < row))
//             {
//                 if (no_mines-- > 0)
//                     minesweeper[i*col+j] = '.';
//                 else
//                     minesweeper[i*col+j] = '*';
//             }
//         }
//         if ((i < col) && (i < row))
//         {
//             if (no_mines-- > 0)
//                 minesweeper[i*col+i] = '.';
//             else
//                 minesweeper[i*col+i] = '*';
//         }
//     }
//    minesweeper[0] = 'c';
}
void print_mines(char minesweeper[],int row,int col)
{
    int i,j;
    for (i = 0;i < row;i++)
    {
        for (j = 0;j < col;j++)
        {
            printf("%c",minesweeper[i*col+j]);
        }
        printf("\n");
    }
    printf("\n");
}
int max(int a, int b)
{
    if (a > b) return a;
    return b;
}
int min(int a, int b)
{
    if (a < b) return a;
    return b;
}
