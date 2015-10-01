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
  command_t current;
  command_stream *next;
};

/*
  first check that cmdtext is valid

  if text is valid create command out of it

  return the command struct
*/
command_t parseCmd(char *cmdtext) {
  command_t t;
  printf("%s",cmdtext);
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
  if (!checkChar(cur))
    error(1,0,"Syntax error (Illegal character found)");

  if (cur=='\n' || cur==';')
    return true;
  return false;
}

command_stream_t
make_command_stream(int (*get_next_byte) (void *),
		     void *get_next_byte_argument)
{
  char cur;
  
  command_stream_t head = (command_stream_t) checked_malloc(sizeof(command_stream));
  command_stream_t tail=head;
 
  //cmd string currently building
  char *cur_cmd=(char *) checked_malloc(sizeof(char));

  cur=get_next_byte(get_next_byte_argument);
  //I don't know what the end of a command is - is it '
  while(feof(get_next_byte_argument)) {

    while (!cmdEnd(cur)) {
      int end=strlen(cur_cmd);
      cur_cmd=(char *) checked_realloc(end+1);
      cur_cmd[end]=cur;
      cur=get_next_byte(get_next_byte_argument);
    }

    if (true/*something*/) {
      tail->current=(command_t) checked_malloc(sizeof(command));
      tail->current=parseCmd(cur_cmd);

      tail->next=(command_stream_t) checked_malloc(sizeof(command_stream));
      tail=tail->next;

    }
  }

  //error (1, 0, "command reading not yet implemented");
  return head;
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
