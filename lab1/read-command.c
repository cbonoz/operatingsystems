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

struct command_stream {
  char stream[N];
  int index;
};

/*
  first check that cmdtext is valid

  if text is valid create command out of it

  return the command struct
*/

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
@param str - string containing command to be parsed
@return command_t - pointer to allocated memory with the defined/parsed command
*/
command_t 
parseCmd(char *str) {

  //length of command string
  int length=strlen(str);

  command_t t = (command_t) checked_malloc(sizeof(struct command));

  //find pointer to first operator in command (if it exists)
  char *op=strpbrk(str,"$*;|");

   if (str[0]=='(') { //opening of subshell
    char *endsub=strpbrk(str,")");
    int subl=endsub-str;
    char *substr=(char *) checked_malloc(subl+1);
    memcpy(substr,str+1,subl);
    substr[subl-1]="\0";
    t->type=SUBSHELL_COMMAND;
    t->subshell_command=parseCmd(substr);
  } else if (op) {
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
      //Split the current complex command string on the operator
      t->command=(command_t *) checked_malloc(sizeof(command_t)*2);

      int leftlen=op-str;
      int rightlen=length-leftlen-1;//-1 to exclude the operator from rightstr

      char *leftstr=(char *)checked_malloc(leftlen+1);
      char *rightstr=(char *)checked_malloc(rightlen+1);

      memcpy(leftstr,str,leftlen);
      memcpy(rightstr,op+1,rightlen);

      t->command[0]=parseCmd(leftstr);
      t->command[1]=parseCmd(rightstr);
  }
 } else /*if (!op)*/ { 
      /*no operator and no bracket in string*/
      t->type=SIMPLE_COMMAND;
      t->word=(char **) checked_malloc(sizeof(char *));
      
      char c;
      //parse the simple command and check for input and output redirections
      bool inmode=false,
        outmode=false;
     
      int ct=0;//counter for chars of word
      int wdct=0;//counter for words

      //construct the simple command struct from str
      for (int i=0;i<length;i++) {
        c=str[i];
        if (!isWordChar(c)||i==length-1) {

          if (c==">")
            outmode=true;
          if (c=="<")
            inmode=true;

          if (ct!=0) {
            int start=i-ct;
            if (inmode) {
              t->input=(char *) checked_malloc(ct+1);
              *(t->input+ct)="\0";
              memcpy(t->input,str+start,ct);
              inmode=false;
            } else if (outmode) {
              t->output=(char *) checked_malloc(ct+1);
              *(t->input+ct)="\0";
              memcpy(t->output,str+start,ct);
              outmode=false;
            } else {
              if (wdct>0)
                t->word(char **) checked_realloc(sizeof(char *)*(wdct+1);

              t->word[wdct]=(char *) checked_malloc(sizeof(ct+1));
              memcpy(t->word[wdct],str+start,ct);
              wdct++;
            }
          }
          ct=0;
          continue;
        }
        else //isWordChar is true - add to character count for current word
          ct++;
      }

      

  }

  free(str);

  return t;
}





//LIU building this
command_stream_t
make_command_stream(int (*get_next_byte) (void *),
		     void *get_next_byte_argument)
{
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
      return NULL;
}

/*read command stream will take the cleaned up version
of the file stream and return a single command_t tree structure
*/
command_t
read_command_stream (command_stream_t s)
{
  //return the parsed command_stream with a pointer to the head command struct
  return parseCmd(s->stream);
}