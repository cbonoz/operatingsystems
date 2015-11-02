// UCLA CS 111 Lab 1 command execution
//part 1b


#include "command.h"
#include "command-internals.h"

#include <error.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>

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

void exec_simple(command_t c, int time_travel) {
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
void exec_sequence(command_t c, int time_travel) {
	pid_t childpid;
	int procStatus;
	if (!(childpid = fork())) {
		//if child process
		execute_command(c->u.command[0], time_travel);
		exit(command_status(c->u.command[0]));
	} else {
		waitpid(childpid, &procStatus, 0);
		execute_command(c->u.command[1], time_travel);
		c->status=command_status(c->u.command[1]);
		
	}
}
void exec_and(command_t c, int time_travel) {
	pid_t childpid;
	int procStatus;
	if (!(childpid = fork())) {
		execute_command(c->u.command[0], time_travel);
		exit(command_status(c->u.command[0]));
		//if child process
	} else {
		waitpid(childpid, &procStatus, 0);
		c->status = WEXITSTATUS(procStatus);
		// c->status=WEXITSTATUS(status);
		if (procStatus==0) { //if cnd[0] was true, check cmd[1]
			execute_command(c->u.command[1], time_travel);
			//assign result of & to right side
			c->status=command_status(c->u.command[1]);	
		}
		
	}
}
void exec_or(command_t c, int time_travel) {
	pid_t childpid;
	int procStatus;
	if (!(childpid = fork())) {
		execute_command(c->u.command[0], time_travel);
		exit(command_status(c->u.command[0]));
		//if child process
	} else {
		waitpid(childpid, &procStatus, 0);
		c->status = WEXITSTATUS(procStatus);
		// c->status=WEXITSTATUS(status);
		if (c->status!=0) { //if cnd[0] was false, check cmd[1]
			execute_command(c->u.command[1], time_travel);
			//assign result of & to right side
			c->status=command_status(c->u.command[1]);	
		}
		
	}
}
//implementation taken from discussion section
//needs to be checked (probably has bugs)
void exec_pipe(command_t c, int time_travel) {
	pid_t pipefd[2], left=0, right=0;
	pipe(pipefd);// create the pipe objects
	if (!(left=fork())) {
		dup2(pipefd[1],1);//taking stdout and pointing to buffer
		close(pipefd[0]);
		execute_command(c->u.command[0], time_travel);//execute nested commands recursively
		exit(command_status(c->u.command[0]));
	}
	else {
		int procStatus=0; 
		waitpid(left, &procStatus, 0);
		//c->status = WEXITSTATUS(procStatus);
		// c->status=WEXITSTATUS(status);
		dup2(pipefd[0],0);//0 is stdin
		close(pipefd[1]);
		execute_command(c->u.command[1], time_travel);
		//assign result of & to right side
		c->status=command_status(c->u.command[1]);	
		
		// //should be a wait here on left
		// if (!(right=fork())) { //this part is the child process
		// 	dup2(pipefd[0],0);//0 is stdin
		// 	close(pipefd[1]);
		// 	execute_command(c->u.command[1], time_travel);
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

void exec_subshell(command_t c, int time_travel) {
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

		execute_command(c->u.subshell_command, time_travel);
		exit(command_status(c->u.subshell_command));
		//if child process
	} else {
		waitpid(childpid, &procStatus, 0);
		c->status=WEXITSTATUS(procStatus);
	}
}

void
execute_command (command_t c, int time_travel)
{
	//ctype_t ctype=c->type;//may not be necessary
	if (c!=NULL) {
		switch(c->type) {
			case AND_COMMAND:
				exec_and(c, time_travel);
				break;
		    case SEQUENCE_COMMAND:
		    	exec_sequence(c, time_travel);
		    	break;
		    case OR_COMMAND:
		    	exec_or(c, time_travel);
		    	break;
		    case PIPE_COMMAND:
		    	exec_pipe(c, time_travel);
		    	break;
		    case SIMPLE_COMMAND:
		    	exec_simple(c, time_travel);
		    	break;
		    case SUBSHELL_COMMAND:
		    	exec_subshell(c, time_travel);
		    	break;
		    default:
		    	printf("type: %d\n",c->type);
		    	error (1, 0, "Invalid type detected");
		    	break;
	    }
	}

}
