// UCLA CS 111 Lab 1 main program

#include <errno.h>
#include <error.h>
#include <getopt.h>
#include <stdio.h>

#include <stdlib.h>
#include <string.h>

#include "command.h"
#include "command-internals.h"
#include "alloc.h"
#include "stdbool.h"

#include <unistd.h>
#include <sys/wait.h>

static char const *program_name;
static char const *script_name;

#define SCRIPT "a&&b"

//define Linked List for READ/WRITE list
typedef struct node{
  char* data;
  struct node* next;
}node_t;

typedef struct nodei{
  int data;
  struct nodei* next;
}nodei_t;

static void
usage (void)
{
  error (1, 0, "usage: %s [-pt] SCRIPT-FILE", program_name);
}

static int
get_next_byte (void *stream)
{
  return getc (stream);
}

void addToList(node_t** list, int i, char* data)
{
  node_t* temp = list[i]; 
  list[i] = (node_t*)checked_malloc(sizeof(node_t));
  list[i]->data = data;
  list[i]->next = temp;
}


//builds the READ and WRITE list for each complete command
void buildReadWriteList (command_t c, node_t** readList, node_t** writeList, int i)
{
  switch (c->type)
    {
      case AND_COMMAND:
      case SEQUENCE_COMMAND:
      case OR_COMMAND:
      case PIPE_COMMAND:
        buildReadWriteList(c->u.command[0], readList, writeList, i);
        buildReadWriteList(c->u.command[1], readList, writeList, i);
        break;
      case SIMPLE_COMMAND:
      {
        //Add words following a simple command to READ list
        int j;
        for (j=1; c->u.word[j] != NULL; j++)
        {
          addToList(readList, i, c->u.word[j]);
        }
        //add input redirection to READ list
        if(c->input)
        {
          addToList(readList, i, c->input);
        }    
        //add output redirection to WRITE list
        if(c->output)
        {
          addToList(writeList, i, c->output);  
        }
        break;
      }
      case SUBSHELL_COMMAND:
        //add input redirection to READ list
        if(c->input)
        {
          addToList(readList, i, c->input);
        }

        //add output redirection to WRITE list
        if(c->output)
        {
          addToList(writeList, i, c->output);
        }
        break;
    }
}

void makeRowZero(int** depGraph, int size, int i)
{
  int j;
  for (j = 0; j<size; j++)
  {
    depGraph[i][j]=0;
  }
}

bool isColZero(int** depGraph, int size, int i)
{
  int j;
  for (j = 0; j<size; j++)
  {
    if(depGraph[j][i]==1) 
    {
      return false;
    }
  }
  return true;
}

int
main (int argc, char **argv)
{
  int opt;
  int command_number = 1;
  int print_tree = 0;
  int time_travel = 0;
  int make=1;
  program_name = argv[0];

  for (;;)
    switch (getopt (argc, argv, "pt"))
      {
      case 'p': print_tree = 1; break;
      //case 'm': print_tree = 1; make=0; break;
      case 't': time_travel = 1; break;
      default: usage (); break;
      case -1: goto options_exhausted;
      }
  options_exhausted:;

  // There must be exactly one file argument.
  if (optind != argc - 1)
    usage ();

  script_name = argv[optind];
  FILE *script_stream = fopen (script_name, "r");
  if (! script_stream)
    error (1, errno, "%s: cannot open", script_name);
  command_stream_t command_stream = make_command_stream (get_next_byte, script_stream);
  /*
  if (make)
    command_stream=make_command_stream (get_next_byte, script_stream);
  else {
    command_stream=(command_stream_t) malloc(sizeof command_stream);
    char str[]=SCRIPT;
    memcpy(command_stream->stream,str,strlen(str));
    command_stream->index=0;
  }
  */

  command_t last_command = NULL;
  command_t command;

  command_t* commandArr = (command_t*)checked_malloc(sizeof(command_t));
  int commandArrSize = 0;

  //build the command array
  while ((command = read_command_stream (command_stream)))
  {
    commandArr[commandArrSize] = command;
    commandArrSize++;
    commandArr = (command_t*)checked_realloc(commandArr, sizeof(command_t)*(commandArrSize+1));
  }
  commandArr[commandArrSize] = NULL;

  //print, execute normally or execute time travel
  int i = 0;
  if (print_tree)
  {
    while(commandArr[i])
    {
      printf ("# %d\n", command_number++);
      print_command (commandArr[i]);
      i++;
    }
  }
  else if (!time_travel)
  {
    while(commandArr[i])
    {
      last_command = commandArr[i];
      execute_command(commandArr[i], time_travel);
      i++;
    }
  }
  else //time_travel
  {
    //initialize READ/WRITE list
    node_t** readList = (node_t**)checked_malloc(sizeof(node_t*)*commandArrSize);
    node_t** writeList = (node_t**)checked_malloc(sizeof(node_t*)*commandArrSize);
    for (i = 0; i < commandArrSize; i++)
    {
      readList[i] = NULL;
      writeList[i] = NULL;
    }

    //build READ/WRITE list
    for (i = 0; i < commandArrSize; i++)
    {
      buildReadWriteList(commandArr[i], readList, writeList, i);
    }
      
    //Initialize dependency graph matrix
    int** depGraph = (int **)checked_malloc(sizeof(int*)*commandArrSize);
    int j;
    for (j = 0; j<commandArrSize; j++)
    {
      depGraph[j] = (int*)checked_malloc(sizeof(int)*commandArrSize);
      memset(depGraph[j], 0, sizeof(int)*commandArrSize);
    }

    //update dependency graph matrix based on READ/WRITE list
    int k, l;
    node_t* n;
    node_t* m;
    bool found; 
    for (k = 0; k<commandArrSize; k++)
    {
      //build dependency by comparing with the readList of all the remaining writeLists
      for (l = k+1; l<commandArrSize; l++)
      {
        
        found = false;

        n = readList[k];
        while(n && !found)
        {
          //WAR dependency
          m = writeList[l];
          while(m && !found)
          {
            if(strcmp(n->data, m->data)==0)
            {
              depGraph[k][l] = 1;
              found = true;
            }
            m = m->next;
          }
          n = n->next;
        }

        n = writeList[k];
        while(n && !found)
        {
          //WAW dependency
          m = writeList[l];
          while(m && !found)
          {
            if(strcmp(n->data, m->data)==0)
            {
              depGraph[k][l] = 1;
              found = true;
            }
            m = m->next;
          }
          //RAW depedency
          m = readList[l];
          while(m && !found)
          {
            if(strcmp(n->data, m->data)==0)
            {
              depGraph[k][l] = 1;
              found = true;
            }
            m = m->next;
          }
          n = n->next;
        }   
      }  
    }
    //print dependency matrix for testing purposes
    for (i = 0; i<commandArrSize; i++)
    {
      for (j = 0; j<commandArrSize; j++)
      {
        printf("%d ", depGraph[i][j]);
      }
      printf("\n");
    }
    
    
    //fork and execute from here    
    int* execTracker = (int*)checked_malloc(sizeof(int)*commandArrSize);
    memset(execTracker, 0, sizeof(int)*commandArrSize);
    
    int countT = 0;
    int execSize, procStatus;
    pid_t childpid;
    nodei_t* execList;

    int x = 1;
    
    while(countT < commandArrSize)
    {
      
      printf("parallelization %d started \n", x);
      execList = (nodei_t*)checked_malloc(sizeof(nodei_t));
      execList = NULL;

      //build the list of all available command to be executed in this round
      for(i=0; i<commandArrSize; i++)
      {
        //find the next available command in this round
        if(!execTracker[i]&&isColZero(depGraph,commandArrSize,i))
        {
          nodei_t* temp = execList;
          execList = (nodei_t*)checked_malloc(sizeof(nodei_t));
          execList->data = i;
          execList->next = temp;

          execTracker[i]=1;
          countT++;

          //printf("%d ", execList->data);
        }
      }

      
      //execute in parallel

      nodei_t* count = execList;
      while(count)
      {
        if (!(childpid = fork())) 
        {  
          execute_command(commandArr[count->data], time_travel);
          exit(commandArr[count->data]->status);
        } 
        else 
        {
          count = count->next;
        }
      }

      //wait for parallel process to finish
      while(execList)
      {
        waitpid(-1, &procStatus, 0);
        makeRowZero(depGraph, commandArrSize, execList->data);
        execList = execList->next;
      }  

      // printf("\n");
      // for (i = 0; i<commandArrSize; i++)
      // {
      //   for (j = 0; j<commandArrSize; j++)
      //   {
      //     printf("%d ", depGraph[i][j]);
      //   }
      //   printf("\n");
      // }

      printf("parallelization %d completed \n\n", x++);
      
      
    }
    
      

    free(depGraph);
    free(readList);
    free(writeList);
  }

  // while ((command = read_command_stream (command_stream)))
  // {
  //   if (print_tree)
  // 	{
  // 	  printf ("# %d\n", command_number++);
  // 	  print_command (command);
      
  // 	}
  //   else
  // 	{
  // 	  last_command = command;
  // 	  execute_command (command, time_travel);
  // 	}
  // }

  free(command_stream);
  free(commandArr);
  

  return print_tree || !last_command ? 0 : command_status (last_command);
}
