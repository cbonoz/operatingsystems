// UCLA CS 111 Lab 1 command reading

#include "command.h"
#include "command-internals.h"
#include "alloc.h"

#include <error.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>

#define N 10000

/* FIXME: You may need to add #include directives, macro definitions,
   static function definitions, etc.  */

/* FIXME: Define the type 'struct command_stream' here.  This should
   complete the incomplete type declaration in command.h.  */

/*


*/
typedef enum command_type cmd_type;

struct command_stream {
  char a[N];
  int index;
};

/*
  first check that cmdtext is valid

  if text is valid create command out of it

  return the command struct
*/
command_t
detectType(char *cmdtext) {
  return NULL;
}

void
stripChar(char *str, char strip)
{
    char *p, *q;
    for (q = p = str; *p; p++)
        if (*p != strip)
            *q++ = *p;
    *q = '\0';
}

command_t 
parseCmd(char *str) {
  int l=strlen(str)

  command_t t = (command_t) checked_malloc(sizeof(struct command));

  if (str[0]=='(' and str[l-1]==')') { //subshell
    str=substr(str,1,l-1);
    t->type=SUBSHELL_COMMAND;
    t->subshell=parseCmd(str);
 } else if (/*no operator and no bracket in string*/) { //use strpbrk
      t->type=SIMPLE_COMMAND
      t->word=(char **) checked_malloc(sizeof(char *));
      //now read and parse the simple command string

     



  } else (/*find the greatest precedence operator not in bracket*/) {
      //this is a complex command -> now need to determine type
      switch(op) {
        case ";":
          t->type=SEQUENCE_COMMAND;
          break;
        case "||":
          t->type=OR_COMMAND;
          break;
        case "&&":
          t->type=AND_COMMAND;
          break;
        case "|":
          t->type=PIPE_COMMAND;
          break;
        default:
          //should not get here
          break;

      }
      //Now split the current command string on the operator
      t->command=(command_t) checked_malloc(sizeof(struct command)*2);
      t->command[0]=parseCmd(leftstr);
      t->command[1]=parseCmd(rightstr);

    }





  return t;
}

helper function for verifying chars in the input file stream are valid
bool checkChar(char c) {
  switch(c) {


    default:
      return true;
      break;
  }

  return true;
}

bool isOperator(char *c) {
  switch(*c) {
    case "||":
    case "&&":
    case ";":
    case "|":
      return true;
      break;



    default:
        return false;
        break;
  }
}


command_stream_t
make_command_stream(int (*get_next_byte) (void *),
		     void *get_next_byte_argument)
{
  //read and validate the input file stream
   b=get_next_byte(get_next_byte_argument);
  //b is the character before a new line character, 
   //needs to be treated specially
 

  //psuedocode for replacing newline in the input stream 
   //to be parsed by parse command
   if (isOperator(b)): newline=space
      else if (b=="("): newline=space
      else if (b==")"): newline=";"
      if (b==word): newline==";"


}
/*read command stream will take the cleaned up version
of the file stream and return a single command_t tree structure
*/
command_t
read_command_stream (command_stream_t s)
{


}
