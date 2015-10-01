// UCLA CS 111 Lab 1 command reading

#include "command.h"
#include "command-internals.h"
#include "alloc.h"

#include <error.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

/* FIXME: You may need to add #include directives, macro definitions,
   static function definitions, etc.  */

/* FIXME: Define the type 'struct command_stream' here.  This should
   complete the incomplete type declaration in command.h.  */

/*
command_stream is linked list of commands coming through the filestream
make_command_stream parses the enter filestream and returns 
*/

struct command_stream {
  command_t *current;
  command_stream *next;
};

/*
  first check that cmdtext is valid

  if text is valid create command out of it

  return the command struct
*/

command_t parseCmd(char *cmdtext) {
  command_t t;
  return t;
}

bool checkChar(char c) {
  switch(c) {


    default:
      return true;
      break;
  }

  return true;
}

bool cmdEnd(char c) {
  return false;
}

command_stream_t
make_command_stream(int (*get_next_byte) (void *),
		     void *get_next_byte_argument)
{
    char cur;
    char prev;
    
    command_stream_t stream = (command_stream_t) checked_malloc(sizeof(command_stream));
   
   char *cur_cmd=(char *) checked_malloc(sizeof(char));
   /*
   while (cur=get_next_byte(get_next_byte_argument)) {

      if (!checkChar(cur))
        error(1,0,"Syntax error (Illegal character found)");

      if (cmdEnd(cur))
        command_t p = (command_t) checked_malloc(sizeof(command_t))
        p=parseCmd(cur_cmd);

        if (p) {
          stream->next=malloc()
        }

      while (!checkCmdEnd(cur)) {

      }
      //string s += cur;
      //parseCmd()
   }
  */

   //return stream;

  /*
    make_command_stream parses the file stream 



  */
  /* FIXME: Replace this with your implementation.  You may need to
     add auxiliary functions and otherwise modify the source code.
     You can also use external functions defined in the GNU C Library.  */
  error (1, 0, "command reading not yet implemented");
  return 0;
}

command_t
read_command_stream (command_stream_t s)
{
  /* FIXME: Replace this with your implementation too.  */
  error (1, 0, "command reading not yet implemented");
  /*
  do {
    print_command(s.current)
  } while (s.next)
  */

  return 0;
}
