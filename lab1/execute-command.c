// UCLA CS 111 Lab 1 command execution
//part 1b


#include "command.h"
#include "alloc.h"
#include "command-internals.h"

#include <error.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdbool.h>
#include <string.h>

typedef enum command_type ctype_t;

/* FIXME: You may need to add #include directives, macro definitions,
   static function definitions, etc.  */

/*
command type:
simple (childpidurn exit status of command)
sequence (childpidurn exit status of last command), 
and/or (childpidurn exit status), 
pipe, 
subshell
)
*/

//define Linked List nodes for READ/WRITE time_travel list
typedef struct node{
  char* data;
  struct node* next;
}node_t;

typedef struct nodei{
  int data;
  struct nodei* next;
}nodei_t;


int
command_status (command_t c)
{
  return c->status;
}
/*
execute_command is the overseer for the command tree traversal process (controlled by parent)
will need to determine the current command type (and behave accordingly) and how to fork
*/

//create shells for the commands, these will each need to be implemented

void exec_simple(command_t c) {
	pid_t childpid;
	int procStatus;
	if (!(childpid = fork())) {
		
		if (c->output) {
			FILE *fp = fopen(c->output, "w");
			dup2(fileno(fp),1);//taking stdout and pointing to buffer
			//fclose(fp);
		}
		if (c->input) {
			FILE *fp = fopen(c->input, "r");
			dup2(fileno(fp), 0);
			//fclose(fp);
		}

		execvp(c->u.word[0], c->u.word);

		//if child process
	} else {
		waitpid(childpid, &procStatus, 0);
		c->status=WEXITSTATUS(procStatus);
	}
}

/*treat this command as 3 simple commands. Call fork first, then wait for it to finish, then fork again...etc*/
void exec_sequence(command_t c) {
	pid_t childpid;
	int procStatus;
	if (!(childpid = fork())) {
		//if child process
		execute_command(c->u.command[0]);
		exit(command_status(c->u.command[0]));
	} else {
		waitpid(childpid, &procStatus, 0);
		execute_command(c->u.command[1]);
		c->status=command_status(c->u.command[1]);
		
	}
}
void exec_and(command_t c) {
	pid_t childpid;
	int procStatus;
	if (!(childpid = fork())) {
		execute_command(c->u.command[0]);
		exit(command_status(c->u.command[0]));
		//if child process
	} else {
		waitpid(childpid, &procStatus, 0);
		c->status = WEXITSTATUS(procStatus);
		// c->status=WEXITSTATUS(status);
		if (procStatus==0) { //if cnd[0] was true, check cmd[1]
			execute_command(c->u.command[1]);
			//assign result of & to right side
			c->status=command_status(c->u.command[1]);	
		}
		
	}
}
void exec_or(command_t c) {
	pid_t childpid;
	int procStatus;
	if (!(childpid = fork())) {
		execute_command(c->u.command[0]);
		exit(command_status(c->u.command[0]));
		//if child process
	} else {
		waitpid(childpid, &procStatus, 0);
		c->status = WEXITSTATUS(procStatus);
		// c->status=WEXITSTATUS(status);
		if (c->status!=0) { //if cnd[0] was false, check cmd[1]
			execute_command(c->u.command[1]);
			//assign result of & to right side
			c->status=command_status(c->u.command[1]);	
		}
		
	}
}
//implementation taken from discussion section
//needs to be checked (probably has bugs)
void exec_pipe(command_t c) {
	pid_t pipefd[2], left=0, right=0;
	pipe(pipefd);// create the pipe objects
	if (!(left=fork())) {
		dup2(pipefd[1],1);//taking stdout and pointing to buffer
		close(pipefd[0]);
		execute_command(c->u.command[0]);//execute nested commands recursively
		exit(command_status(c->u.command[0]));
	}
	else {
		int procStatus=0; 
		waitpid(left, &procStatus, 0);
		//c->status = WEXITSTATUS(procStatus);
		// c->status=WEXITSTATUS(status);
		dup2(pipefd[0],0);//0 is stdin
		close(pipefd[1]);
		execute_command(c->u.command[1]);
		//assign result of & to right side
		c->status=command_status(c->u.command[1]);	
		
		// //should be a wait here on left
		// if (!(right=fork())) { //this part is the child process
		// 	dup2(pipefd[0],0);//0 is stdin
		// 	close(pipefd[1]);
		// 	execute_command(c->u.command[1]);
		// 	exit(command_status(c->u.command[1]));
			
		// } else {
		// 	int procStatus=0; 
		// 	int childpid = waitpid(-1,&procStatus,0);//wait on all child processes
		// 	if (childpid == right) { //this means the right process has finished
		// 		c->status = WEXITSTATUS(procStatus);//extract the childpidurn status from the status pointer from the right
		// 		waitpid(left,&procStatus,0);//wait for the left to finish
		// 	} else { //if the left process has finished
		// 		waitpid(right,&procStatus,0); //wait for the right
		// 		c->status=WEXITSTATUS(procStatus);	//childpidurn the status from the right process
		// 	}
		// }
	}
}

void exec_subshell(command_t c) {
	pid_t childpid;
	int procStatus;
	if (!(childpid = fork())) {
		

		if (c->output) {
			FILE *fp = fopen(c->output, "w");
			dup2(fileno(fp),1);//taking stdout and pointing to buffer
			//fclose(fp);
		}
		if (c->input) {
			FILE *fp = fopen(c->input, "r");
			dup2(fileno(fp), 0);
			//fclose(fp);
		}

		execute_command(c->u.subshell_command);
		exit(command_status(c->u.subshell_command));
		//if child process
	} else {
		waitpid(childpid, &procStatus, 0);
		c->status=WEXITSTATUS(procStatus);
	}
}




/*
Only worry about parellelism within the current command tree (don't try and optimize outside of the given tree)
@param c command_t tree to run
@param time_travel bool if doing time_travel optimization
*/
void
execute_command (command_t c)
{
	//ctype_t ctype=c->type;//may not be necessary
	if (c!=NULL) {
		switch(c->type) {
			case AND_COMMAND:
				exec_and(c);
				break;
		    case SEQUENCE_COMMAND:
		    	exec_sequence(c);
		    	break;
		    case OR_COMMAND:
		    	exec_or(c);
		    	break;
		    case PIPE_COMMAND:
		    	exec_pipe(c);
		    	break;
		    case SIMPLE_COMMAND:
		    	exec_simple(c);
		    	break;
		    case SUBSHELL_COMMAND:
		    	exec_subshell(c);
		    	break;
		    default:
		    	printf("type: %d\n",c->type);
		    	error (1, 0, "Invalid type detected");
		    	break;
	    }
	}

}


void 
print_graph(int **g, int n) {
	int i,j;
	for (i = 0; i<n; i++)
    {
      for (j = 0; j<n; j++)
      {
        printf("%d ", g[i][j]);
      }
      printf("\n");
    }
}


void 
addToList(node_t** list, int i, char* data)
{
  node_t* temp = list[i]; 
  list[i] = (node_t*)checked_malloc(sizeof(node_t));
  list[i]->data = data;
  list[i]->next = temp;
}


//builds the READ and WRITE list for each complete command
void 
buildReadWriteList (command_t c, node_t** readList, node_t** writeList, int i)
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

void 
makeRowZero(int** depGraph, int size, int i)
{
  int j;
  for (j = 0; j<size; j++)
  {
    depGraph[i][j]=0;
  }
}

bool 
isColZero(int** depGraph, int size, int i)
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

void
execute_tt(command_t *commandArr, int commandArrSize) {
	int i,j;

	
	
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
    print_graph(depGraph, commandArrSize);
    
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
      
      printf("---\nparallelization %d started \n", x);
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
          execute_command(commandArr[count->data]);
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

      printf("\nparallelization %d completed \n", x++);
      
      
    }
    
    free(depGraph);
    free(readList);
    free(writeList);

}


void execute_general(command_t *commandArr, int commandArrSize, command_t last_command, int time_travel) {
	if (time_travel) 
		execute_tt(commandArr, commandArrSize);
	else {
		int i=0;	

		while(commandArr[i])
		{
			last_command = commandArr[i];
			execute_command(commandArr[i]);
			i++;
		}
	}
}

