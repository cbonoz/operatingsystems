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
#include <ctype.h>

//#define N 10000
#define ENDCHAR '@'
#define MAXITER 25

static bool debug=0;

static int iters=0;

/* FIXME: You may need to add #include directives, macro definitions,
   static function definitions, etc.  */

/* FIXME: Define the type 'struct command_stream' here.  This should
   complete the incomplete type declaration in command.h.  */

typedef enum command_type cmd_type;



struct command_stream {
  char *stream;
  int index;
};




bool 
isSpecial(char c) {
  switch(c) {
    case '!':
    case '%':
    case '+':
    case ',':
    case '-':
    case '.':
    case '/':
    case ':':
    case '@':
    case '^':
    case '_':
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
    case '$'://||
    case '*'://&&
    case ';':
    case '|':
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
    free(t->u.word);
    if(t->u.command) {
      freeCmd(t->u.command[0]);
      freeCmd(t->u.command[1]);
    }
    freeCmd(t->u.subshell_command);
    free(t);
  }
}

void freeStream(command_stream_t s) {
  free(s);
}


/*
parseCmd
@param start - pointer to command string start
@param end - pointer to command string end
@return command_t - pointer to allocated memory with the defined/parsed command
*/
command_t 
parseCmd(char *start, char *end) {
  if (start>end || iters++>MAXITER) return NULL;

  //printf("parsing: %.*s \n", end-start+1, start);

  command_t t = (command_t) checked_malloc(sizeof(struct command));

  char *ptr=start;
  
  bool subshell=false;

  if (*ptr=='(') { //opening of subshell
    subshell=true;
    int openparen=1;
    //printf("subshell detected\n");

    //find end of subshell
    while (openparen>0) {
      ptr++;
      char c=*ptr;
      if (c == '(') {
        openparen++;
      } else if (c==')') {
        openparen--;
      }
    } 
  }


  
  char *op=strpbrk(ptr+1,"$*;|");
  
  if (op && op<end) { // if operator in expression
      //printf("op: %c\n",*op);
      switch(*op) {
        case ';':
          t->type=SEQUENCE_COMMAND;
          break;
        case '$':
          t->type=OR_COMMAND;
          break;
        case '*':
          t->type=AND_COMMAND;
          break;
        case '|':
          t->type=PIPE_COMMAND;
          break;
        default:
          error(1,0,"illegal operator detected");
          //should not get here
          break;
        }
      //printf("complex command type%d: %.*s %.*s\n", t->type, op-start, start,end-op,op+1);
      //t->u.command=(command_t *) checked_malloc(sizeof(command_t)*2);
      
      t->u.command[0]=parseCmd(start,op-1);
      t->u.command[1]=parseCmd(op+1,end);
      
    
  } else if (subshell) { //if subshell
      //printf("subshell command\n");
    t->type=SUBSHELL_COMMAND;
    t->u.subshell_command=(command_t) checked_malloc(sizeof(command_t));
    t->u.subshell_command=parseCmd(start+1,ptr-1);
  } else { //simple command with no op and no subshell
      //printf("simple command\n");
      t->type=SIMPLE_COMMAND;
      t->u.word=(char **) checked_malloc(sizeof(char *));
      char c;
      
      bool inmode=false,
        outmode=false;
     
      int ct=0;//character count tracker for word
      int wdct=0;//word count tracker

      //construct the simple command struct from str - check for redirections
      ptr=start;
      
      while (ptr<=end) {
        c=*ptr;
        bool isEnd=ptr==end;
        //printf("sc iteration (char %c, in:%d, out: %d): %d\n",c,inmode,outmode,ct);
        if (isEnd) ct++;

        if (isWordChar(c) && !isEnd)
          ct++;
        else { //word ended - allocate it in command struct
          if (ct>0 || isEnd) {
            
            char *wstart = ptr-ct;
            if (isEnd)wstart++;
            //printf("allocating:%.*s\n", ct, wstart);
            if (inmode) {
              t->input=(char *) checked_malloc(ct+1);
              t->input[ct]='\0';
              memcpy(t->input,wstart,ct);
              inmode=false;
            } else if (outmode) {
              t->output=(char *) checked_malloc(ct+1);
              t->output[ct]='\0';
              memcpy(t->output,wstart,ct);
              outmode=false;
            } else {
              if (wdct>0) {
                t->u.word=(char **) checked_realloc(t->u.word,sizeof(char *) * (wdct+1));
              }
              t->u.word[wdct]=(char *) checked_malloc(sizeof(ct+1));
              t->u.word[wdct][ct]='\0';
              memcpy(t->u.word[wdct++],wstart,ct);
            }
          }
          ct=0;
          if (c=='>')
            outmode=true;
          if (c=='<')
            inmode=true;   
        }

        c=*++ptr;
      }    
    }
  return t;
}
/*
command_stream_t
commandToStream(command_t t, command_stream_t s) {
  s=(command_stream_t) checked_malloc(sizeof command_stream);
  s->cmd=*t;

  switch(t->type) {
    case AND_COMMAND:         // A && B
    case SEQUENCE_COMMAND:    // A ; B
    case OR_COMMAND:          // A || B
    case PIPE_COMMAND:        // A | B
      command_stream_t tmp=commandToStream(t->u.command[0],s->next);//need tmp in case command[0] is nested
      commandToStream(t->u.command[1],tmp->next);
      break;
    case SIMPLE_COMMAND:      // a simple command
      s->next=NULL;
      return s;
      break;
    case SUBSHELL_COMMAND:    //( A )
      commandToStream(t->u.subshell_command,s->next);
      return s;
      break;
  }

}
*/
/*
b is character before the newline
if (isOperator(b)): newline=space
      else if (b=="("): newline=space
      else if (b==")"): newline=";"
      if (b==word): newline==";"
*/
char *
replace(char *p) {
  char b=*(p-1);
  switch(*p) {
    case '&':
      if (*(p+1)=='&') {
        *(p+1)=' ';
        *p='*';
      } else {
        error(1,0,"Illegal single & found");
      }
      break;
    case '|':
      if (*(p+1)=='|') {
        *(p+1)=' ';
        *p='$';
      }
      break;
    case '\n':
      if (isOperator(p-1)) *p=' ';
      else if (b=='(') *p=' ';
      else if (b==')') *p=';';
      else if (isWordChar(b)) *p==';';
      else if (*(p+1)=='\n') {
        //printf("\n2 newlines detected");
        *p=='@';
        *(p+1)==' ';
      }
      else *p=' ';
      break;
    case '#':
      *p=' ';
      while (*++p != '\n') {
        *p=' ';
      }
      break;
    case '\t':
      *p=' ';
      break;

  }
  return p+1;
}


//LIU building this
command_stream_t
make_command_stream(int (*get_next_byte) (void *),
		     void *get_next_byte_argument)
{
  command_stream_t t=(command_stream_t) checked_malloc(sizeof(struct command_stream));

  int i=0;
  char c;

  char *str=(char *) checked_malloc(1);
  while (!feof(get_next_byte_argument)) {
    char c=get_next_byte(get_next_byte_argument);
    str[i++]=c;
    str=(char *) checked_realloc(str, sizeof(char)*(i+1));
  }
  str[i-1]='\0';
  char *ptr=str;
  while ((ptr=strpbrk(ptr,"#&|\n")) && ptr<str+i) {
    //printf("found %c",*ptr);
    ptr=replace(ptr);
  }
  if (debug) {
  printf("pre: \n%s\n", str);
  printf("post: %s\n", str);
  }

  t->stream=str;
  t->index=0;
  return t;

}


/*read command stream will take the cleaned up version
of the file stream and return a command_t tree. The tree will spit out the commands in order.
*/
//build a stack of commands pop



command_t
read_command_stream (command_stream_t s)
{
  
  int l=strlen(s->stream);
  char *start=s->stream+s->index;
  
  if (*start==ENDCHAR) {
    s->index=s->index+1;
    start++;
  }

  if (s->index<l) {
    char *endptr=start+s->index;
    char c=*endptr;
    while (c != ENDCHAR && c!='\0')
        c=*++endptr;
    //printf("%c",c);
    s->index=endptr - s->stream;
    //printf("index: %d,len: %d\n",s->index,l);
    return parseCmd(start,endptr-1);
  }
  return NULL;
  /*
  if (!s) 
    return NULL;

  command_t c = &(s->cmd);
  s=s->next;

  return c;
  */

}