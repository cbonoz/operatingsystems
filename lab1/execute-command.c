// UCLA CS 111 Lab 1 command execution
//part 1b


#include "command.h"
#include "command-internals.h"

#include <error.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream.h>
#include <ctypes.h>

typedef enum command_type ctype_t;

/* FIXME: You may need to add #include directives, macro definitions,
   static function definitions, etc.  */

/*
command type:
simple (return exit status of command)
sequence (return exit status of last command), 
and/or (return exit status), 
pipe, 
subshell
)
*/


int
command_status (command_t c)
{
  return c->status;
}
/*
execute_command is the overseer for the command tree traversal process (controlled by parent)
will need to determine the current command type (and behave accordingly) and how to fork
*/

void
execute_command (command_t c, int time_travel)
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
    	
    //other stuff

  /* FIXME: Replace this with your implementation.  You may need to
     add auxiliary functions and otherwise modify the source code.
     You can also use external functions defined in the GNU C Library.  */
  //error (1, 0, "command execution not yet implemented");

}

//create shells for the commands, these will each need to be implemented

void exec_simple(command_t c) {
	int ret;
	if (!(ret = fork())) {
		//if child process
	} else {
		waitpid(retpid, &status, 0);
		c->status=command_status(status);
	}
}

/*treat this command as 3 simple commands. Call fork first, then wait for it to finish, then fork again...etc*/
void exec_sequence(command_t c) {
	int ret;
	if (!(ret = fork())) {
		//if child process
	} else {
		waitpid(retpid, &status, 0);
		c->status=command_status(status);
	}
}
void exec_and(command_t c) {
	int ret;
	if (!(ret = fork())) {
		//if child process
	} else {
		waitpid(retpid, &status, 0);
		c->status=command_status(status);
	}
}
void exec_or(command_t c) {
	int ret;
	if (!(ret = fork())) {
		//if child process
	} else {
		waitpid(retpid, &status, 0);
		c->status=command_status(status);
	}
}
//implementation taken from discussion section
//needs to be checked (probably has bugs)
void exec_pipe(command_t c) {
	int pipefd[2]	,left=0, right =0;
	pipe(pipefd);// create the pipe objects
	if (!(left=fork())) {
		dup2(pipefd[1],1);
		close(pipefd[0]);
		exec_command(c->u.command[0]);//execute nested commands recursively
		exit(c->u.command[0]->status);
	}
	else {
		if (!(right=fork())) { //this part is the child process
			dup2(pipefd[0],0);
			close(pipefd[1]);
			exec_command(c->u.command[1]);
			exit(c->u.command[1]->status);
		} else {
			int status=0, retpid=waitpid(-1,&status,0);//wait on all child processes
			if (retpid==right) { //this means the right process has finished
				c->status=WEXITSTATUS(status);//extract the return status from the status pointer from the right
				waitpid(left,&status,0);//wait for the left to finish
			} else { //if the left process has finished
				waitpid(right,&status,0); //wait for the right
				c->status=WEXITSTATUS(status);	//return the status from the right process
			}
		}
	}
}
void exec_subshell(command_t c) {
	int ret;
	if (!(ret = fork())) {
		//if child process
	} else {
		waitpid(retpid, &status, 0);
		c->status=command_status(status);
	}
}
