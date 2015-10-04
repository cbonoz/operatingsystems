// UCLA CS 111 Lab 1 command reading

#include "command.h"
#include "command-internals.h"
#include "alloc.h"

#include <error.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>
#include <regex.h>

#define N 10000

/* FIXME: You may need to add #include directives, macro definitions,
   static function definitions, etc.  */

/* FIXME: Define the type 'struct command_stream' here.  This should
   complete the incomplete type declaration in command.h.  */

typedef enum command_type cmd_type;

/*
struct command_stream {
  char stream[N];
  int index;
  int linenumber;
};
*/

struct command_stream {
  command cmd;
  command_stream_t next;
};



bool 
isSpecial(char c) {
  switch(c) {
    
    case:"!":
    case:"%%":
    case:"+":
    case:",":
    case:"-":
    case:".":
    case:"/":
    case:":":
    case:"@":
    case:"^":
    case:"_":
      return true;
      break;
    default:
      return false;
      break;
      }
}

bool 
isOperator(char *c) {
  switch(*c) {
    case "$"://||
    case "*"://&&
    case ";":
    case "|":
      return true;
      break;
    default:
      return false;
      break;
  }
}

bool
isWordChar(char c) {
  return isalnum(c) || isSpecial(c);
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


void
freeCmd(command_t t) {
  if (t) {
    free(t->input);
    free(t->output);
    free(t->word);
    if(t->command) {
      freeCmd(command[0]);
      freeCmd(command[1]);
    }
    freeCmd(t->subshell_command);
    free(t);
  }
}

/*
parseCmd
@param start - pointer to command string start
#@param end - pointer to command string end
@return command_t - pointer to allocated memory with the defined/parsed command
*/
command_t 
parseCmd(char *start, char *end) {
  if (start==end) return NULL;

  command_t t = (command_t) checked_malloc(sizeof(struct command));

  char *ptr=start;
  bool subshell=false;

  if (*ptr=='(') { //opening of subshell
    subshell=true;
    int openparen=1;

    //find end of subshell
    while (openparen>0) {
      char c=*++ptr;
      if (c == '(')
        openparen++;
      else if (c==')')
        openparen--;
    } 
  }

  char *op=strpbrk(ptr+1,"$*;|");
  if (op) { // if operator in expression
      switch(*op) {
        case ";":
          t->type=SEQUENCE_COMMAND;
          break;
        case "$":
          t->type=OR_COMMAND;
          break;
        case "*":
          t->type=AND_COMMAND;
          break;
        case "|":
          t->type=PIPE_COMMAND;
          break;
        default:
          error(1,0,"illegal operator detected");
          //should not get here
          break;
        }
    
      t->command=(command_t *) checked_malloc(sizeof(command_t)*2);
      t->command[0]=parseCmd(start,op-1);
      t->command[1]=parseCmd(op+1,end);
      
    
  } else if (subshell) { //if subshell
    t->type=SUBSHELL_COMMAND;
    t->subshell_command=(command_t *) checked_malloc(sizeof(command_t));
    t->subshell_command=parseCmd(start+1,ptr-1);
  } else { //simple command with no op and no subshell
      t->type=SIMPLE_COMMAND;
      t->word=(char **) checked_malloc(sizeof(char *));
      char c;
      
      bool inmode=false,
        outmode=false;
     
      int ct=0;//character count tracker for word
      int wdct=0;//word count tracker

      //construct the simple command struct from str - check for redirections
      ptr=start;
      while (ptr!=end+1) {
        c=*ptr++;
        if (!isWordChar(c)) { //if not wordchar 

          if (c==">")
            outmode=true;
          if (c=="<")
            inmode=true;

          if (ct>0) { //word ended - allocate it in command struct
            char *wstart=ptr-ct;
            if (inmode) {
              t->input=(char *) checked_malloc(ct+1);
              *(t->input+ct)="\0";
              memcpy(t->input,wstart,ct);
              inmode=false;
            } else if (outmode) {
              t->output=(char *) checked_malloc(ct+1);
              *(t->input+ct)="\0";
              memcpy(t->output,wstart,ct);
              outmode=false;
            } else {
              if (wdct>0)
                t->word(char **) checked_realloc(sizeof(char *)*(wdct+1);

              t->word[wdct]=(char *) checked_malloc(sizeof(ct+1));
              memcpy(t->word[wdct],wstart,ct);
              wdct++;
            }
          }
          ct=0; 
          
        }
        else //isWordChar is true - add to character count for current word
          ct++;
      }
  }
  return t;
}

command_stream_t
commandToStream(command_t t, command_stream_t s) {
  s=(command_stream_t) checked_malloc(sizeof command_stream);
  s->cmd=*t;

  switch(t->type) {
    case: AND_COMMAND:         // A && B
    case: SEQUENCE_COMMAND:    // A ; B
    case: OR_COMMAND:          // A || B
    case: PIPE_COMMAND:        // A | B
      command_stream_t tmp=commandToStream(t->command[0],s->next);//need tmp in case command[0] is nested
      commandToStream(t->command[1],tmp->next);
      break;
    case: SIMPLE_COMMAND:      // a simple command
      s->next=NULL;
      break;
    case: SUBSHELL_COMMAND:    //( A )
      commandToStream(t->subshell_command,s->next);
      break;
  }
}




//LIU building this
command_stream_t
make_command_stream(int (*get_next_byte) (void *),
		     void *get_next_byte_argument)
{
  char *validated_str;
  validated_str=NULL;
  /*
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

  */
      command_t t=parseCmd(validated_str,validated_str+strlen(validated_str));
      command_stream_t head;
      commandToStream(t,head);
      return head;
}


/*read command stream will take the cleaned up version
of the file stream and return a command_t tree. The tree will spit out the commands in order.
*/
//build a stack of commands pop


command_t
read_command_stream (command_stream_t s)
{
  if (!s) 
    return NULL;

  command_t c = &(s->cmd);
  s=s->next;

  return c;


}