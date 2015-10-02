// UCLA CS 111 Lab 1 command reading

#include "command.h"
#include "command-internals.h"
#include "alloc.h"

#include <error.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>

/* FIXME: You may need to add #include directives, macro definitions,
   static function definitions, etc.  */

/* FIXME: Define the type 'struct command_stream' here.  This should
   complete the incomplete type declaration in command.h.  */

/*
#define N 10000

*/
typedef enum command_type cmd_type;

struct command_stream {
  command_t current;
  command_stream *next;
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
  command_t t;

  const char str2[] = "() <>|";
  char *ret;

  ret = strpbrk(str1, str2);
  while (ret) {
    if(ret) 
    {
      printf("First matching character: %c\n", *ret);
    }
    else 
    {
      printf("Character not found");
    }
  }



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

void freeCS(command_stream_t *t) {
  command_stream_t prev, cur;
  cur=t;
  while (cur) {
    prev=cur;
    free(cur->current)
    cur=cur->next;
    free(prev);
  }
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

  free(cur_cmd);

  //error (1, 0, "command reading not yet implemented");
  return head;
  }
/*read command stream will take the cleaned up version
of the file stream and return a single command_t tree structure
*/
command_t
read_command_stream (command_stream_t s)
{


}
