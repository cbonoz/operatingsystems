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

//used for debugging make_command_stream
//#define SCRIPT "a&&b"


static void
usage (void)
{
  error (1, 0, "usage: %s [-pt] [-n N] SCRIPT-FILE", program_name);
}

static int
get_next_byte (void *stream)
{
  return getc (stream);
}

int
main (int argc, char **argv)
{
  int opt;
  int command_number = 1;
  int print_tree = 0;
  int time_travel = 0;
  int limit_process=0;
  int limit=-1;

  int make=1;
  program_name = argv[0];
  int c;
  while ((c = getopt (argc, argv, "ptn:")) != -1) {
    switch (c)
      {
      case 'p': print_tree = 1; break;
      //case 'm': print_tree = 1; make=0; break;
      case 'n': 
        limit_process=1; 
        limit=atoi(optarg);
        if (limit<=0) //process limit must be positive
          usage();
        break;
      case 't': time_travel = 1; break;
      default: printf("opt parsing error:\n"); usage (); break;
      
      }
  }
  //prints for debugging bash command argument parsing
  
  printf("p: %d n: %d t: %d\nlimit: %d\n", print_tree, limit_process, time_travel, limit);
  /*
  int index;
  for (index = optind; index < argc; index++)
    printf ("Non-option argument %s\n", argv[index]);
  */

  // There must be exactly one file argument.
  if (optind != argc - 1)
    usage ();

  script_name = argv[optind];
  FILE *script_stream = fopen (script_name, "r");
  if (! script_stream)
    error (1, errno, "%s: cannot open", script_name);
  command_stream_t command_stream = make_command_stream (get_next_byte, script_stream);
  /* //used for debugging make_command_stream
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
  else 
  {
    execute_general(commandArr,commandArrSize, last_command, time_travel, limit_process, limit);
  }

  free(command_stream);
  free(commandArr);
  

  return print_tree || !last_command ? 0 : command_status (last_command);
}
