#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include <gc/gc.h>
#include "codejam.h"

int draw_mines(char minesweeper[],int row,int col,int mines);
void print_mines(char minesweeper[],int row,int col);

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
    printf_int3(input->R,input->C,input->M);
    switch (draw_mines(minesweeper,input->R,input->C,input->M))
    {
        case -1:
            input->output = malloc(sizeof(char) * 20);
            sprintf(input->output,"\nImpossible");
            printf("Impossible\n");
            break;
        case 1:
            print_mines(minesweeper,input->R,input->C);
            break;
    }
}
int draw_mines(char minesweeper[],int row,int col,int mines)
{
    int i,j;
    int placed_mines = 0;
    int no_mines = row*col-mines;
    int r,c;
    switch (no_mines)
    {
        case 0:
        case 2:
        case 3:
        case 5:
        case 7:
            return -1;//impossible
    }
    for (i = 0;i < row;i++)
    {
        for (j = 0;j < col;j++)
        {
            minesweeper[i*col+j] = '.';
        }
    }
    for (i = 0;i < row-2;i++)
    {
        for (j = 0;j < col-2;j++)
        {
            minesweeper[i*col+j] = '*';
            placed_mines++;
        }
    }
    //click spot in bottom corner
    minesweeper[(row-1)*col+(col-1)] = 'c';
    
    //set up inital values for r and c
    if (placed_mines > mines)
    {
        r = row-3;
        c = col-3;
    } 
    else
    {
        r = 0;
        c = 0;
    }
    while(placed_mines != mines)
    {
//        printf_int4(row,col,mines,placed_mines);
//        print_mines(minesweeper,row,col);
        //added too many mines
        if (placed_mines > mines)
        {
            minesweeper[col*r+c] = '.';
            if (--c < 0)
            {
                r--;
                c = col-3;
            }
            placed_mines--;
        }
        //didn't add enough mines
        else
        {
            //add two mines
            minesweeper[col*(row-2)+r] = '*';
            minesweeper[col*(row-1)+r] = '*';
            r++;
            placed_mines+=2;
            //should we add two more?
            if ((placed_mines+2) <= mines)
            {
                minesweeper[col*c+(row-2)] = '*';
                minesweeper[col*c+(row-1)] = '*';
                c++;
                placed_mines+=2;
            }
            //are we over by one?
            if ((placed_mines+1) == mines)
            {
                minesweeper[(row-3)*col+col-3] = '.';
            }
        }
    }
    return 1;
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

