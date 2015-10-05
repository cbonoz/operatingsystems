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
#define MAXITER 1000

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
isOperator(char c) {
  switch(c) {
    case '$'://||
    case '*'://&&
    case ';':
    case '|':
    case '>':
    case '<':
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

 char *
 skipWs(char *ptr) {
  while (*ptr==' ')
    ptr++;
  return ptr;
  //return ptr;
}

void
freeCmd(command_t t) {
  if (t) {
    free(t->input);
    free(t->output);
    int ct=0;
    while(t->u.word[ct]!=NULL)
      free(t->u.word[ct++]);
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

bool isCharValid(char currChar)
{
  if(isWordChar(currChar))
    return true;
  switch (currChar){
    case '#':
    case ';':
    case ' ':
    case '\t':
    case '\n':
    case '|':
    case '&':
    case '(':
    case ')':
    case '<':
    case '>':
      return true;
  }
  return false;
}

int nextIndex(char* buffer, int bufferSize, int i)
{
  i++;
  while ((i < bufferSize) && ((buffer[i] == '\t') || (buffer[i] == ' ')))
  {
    i++;
  }
  return i;
}

int nextNonwhitespace(char* buffer, int bufferSize, int i)
{
  i = nextIndex(buffer, bufferSize, i);
  while (buffer[i] == '\n')
  {
    i = nextIndex(buffer, bufferSize, i);
  }
  return i;
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
  start=skipWs(start);

  printf("parsing: %.*s \n", end-start+1, start);

  command_t t = (command_t) checked_malloc(sizeof(struct command));

  char *ptr=start;
  
  
  bool subshell=false;

  

  if (*ptr=='(') { //opening of subshell
    subshell=true;
    int openparen=1;
    ////printf("subshell detected\n");

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
      ////printf("op: %c\n",*op);
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
      //t->u.word=(char **) checked_malloc(sizeof(char *));
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

        

        if (isWordChar(c) && !isEnd)
          ct++;
        else { //word ended - allocate it in command struct

          if (ct>0 || isEnd) {
            if (isEnd) ct++;
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
  
              t->u.word=(char **) checked_realloc(t->u.word,sizeof(char *) * (wdct+1));
              t->u.word[wdct]=(char *) checked_malloc(ct+1);
              memcpy(t->u.word[wdct],wstart,ct);
              t->u.word[wdct][ct]='\0';
              printf("%s after memcpy with wdct %d, ct %d\n",*(t->u.word+wdct),wdct,ct);
              wdct++;
            }
          }
          ct=0;
          if (c=='>')
            outmode=true;
          if (c=='<')
            inmode=true;   
        }
        ptr++;
      }    
    }
  
  return t;
}




command_stream_t
make_command_stream(int (*get_next_byte) (void *),
         void *get_next_byte_argument)
{
  
  //building the stream string
  int lineNum = 1;
  
  //printf("Step 1: Building the buffer string.\n");
  char currChar; 
  char* buffer = (char*) checked_malloc(sizeof(char));
  int bufferSize = 0;
  while((currChar = get_next_byte(get_next_byte_argument)) != EOF)
  {
    if(currChar == '\n')
    {
      lineNum++;
    }
    if(!isCharValid(currChar))
    {
      error(1,0,"%d: Syntax error (Illegal character %c found.) \n", lineNum, currChar);
    }
    else if (currChar == '#')
    {
      //while(currChar != '\n' && currChar != EOF)
      while((currChar = get_next_byte(get_next_byte_argument)) != EOF && currChar != '\n')
      {
      }
      if(feof(get_next_byte_argument))
      {
        error(1,0,"%d: Syntax error (Comments need to be terminated with new line)\n", lineNum);
      }
      else
      {
        lineNum++;
      }
    }
    buffer[bufferSize] = currChar;
    bufferSize++;
    buffer = (char*)checked_realloc(buffer, bufferSize+1);
  }
  buffer[bufferSize] = '\0';
  //printf("Step 1: Buffer Built \n%s\n Strlen(buffer) = %d, bufferSize = %d\n", buffer, strlen(buffer), bufferSize);
  
  
  //printf("Step 2: Clean up iteration started.\n");
  lineNum = 1;
  int prev = -1;
  int curr = nextIndex(buffer, bufferSize, -1);
  int next = nextIndex(buffer, bufferSize, curr);
  while (curr < bufferSize)
  {
    //printf("Step 2: prev = %d, curr = %d, next = %d.\n", prev, curr, next);
    switch (buffer[curr])
    {
      case ';':
      case '>':
      case '<':
        if ((prev==-1) || (nextNonwhitespace(buffer, bufferSize, curr) == bufferSize)
          ||(isOperator(buffer[prev])) || (isOperator(buffer[next])))
        {
          error(1,0,"%d: Syntax error (Incomplete operators %c found)\n", lineNum, buffer[curr]);
        }
        break;        
      case '&':
        if (buffer[next] == '&' && next-curr == 1)
        {
          buffer[curr] = '*';
          buffer[next] = ' ';
          next = nextIndex(buffer, bufferSize, curr);
          
          if ((prev==-1) || (nextNonwhitespace(buffer, bufferSize, curr)==bufferSize)
            ||(isOperator(buffer[prev])) || (isOperator(buffer[next])))
          {
            error(1,0,"%d: Syntax error (Incomplete operators %c found)\n", lineNum, buffer[curr]);
          }
        }
        else
        {
          error(1,0,"%d: Syntax error (Incomplete operators %c found)\n", lineNum, buffer[curr]); 
        }
        break;  
      case '|':
        if (buffer[next] == '|' && next-curr == 1)
        {
          buffer[curr] = '$';
          buffer[next] = ' ';
          next = nextIndex(buffer, bufferSize, curr);
        }
        if ((prev==-1) || (nextNonwhitespace(buffer, bufferSize, curr)==bufferSize)
          ||(isOperator(buffer[prev])) || (isOperator(buffer[next])))
        {
          error(1,0,"%d: Syntax error (Incomplete operators %c found)\n", lineNum, buffer[curr]);
        }
        break;
      case '\n':
        if ((prev!=-1) && (buffer[prev] == '<' || buffer[prev] == '>'))
        {
          error(1,0,"%d: Syntax error (New line character can only follow tokens other than < >.)\n", lineNum);
        }
        
        if (buffer[next] == '\n')
        {
          if(buffer[prev] != '$' && buffer[prev] != '*' && buffer[prev] != '|')
          {
            buffer[curr] = '@';
          }
          else
          {
            buffer[curr] = ' ';
          }
          buffer[next] = ' ';
          lineNum++;
          next = nextIndex(buffer, bufferSize, next);
          while (buffer[next] == '\n')
          {
            buffer[next] = ' ';
            next = nextIndex(buffer, bufferSize, next);
            lineNum++;
          }
        }
        else if ((prev!=-1) && (next!=bufferSize) && ((isOperator(buffer[prev])) || (buffer[prev]=='(')))
        {
          buffer[curr] = ' ';
        }
        else if ((prev!=-1) && (next!=bufferSize) && ((isWordChar(buffer[prev])) || (buffer[prev]==')')))
        {
          buffer[curr] = ';';
        }

        if ((next!=bufferSize)
          && (!(buffer[next] == '(' || buffer[next]==')' || isWordChar(buffer[next]))))
        {
          error(1,0,"%d, Syntax error (New line character can only be followed by (, ), or Words.)\n", lineNum);
        }
        
        lineNum++;
        break;
    }
    prev = curr;
    curr = next;
    next = nextIndex(buffer, bufferSize, curr);  
  }
  //printf("Step 2: Buffer cleaned \n%s\n Strlen(buffer) = %d, bufferSize = %d\n", buffer, strlen(buffer), bufferSize);
  
  //printf("Step 3: Parenthesis check start.\n");
  int stackSize = 0;
  int i;
  for (i = 0; i < bufferSize; i++)
  {
    if (buffer[i] == '(')
    {
      stackSize++;
    }
    else if (buffer[i] == ')')
    {
      if(stackSize > 0)
      {
        stackSize--;
      }
      else
      {
        error(1,0,"Syntax error (Unbalanced parenthesis found)\n");
      }
    }
  }
  if (stackSize > 0)
  {
    error(1,0,"Syntax error (Unbalanced parenthesis found)");
  }
  //printf("Step 3: Parenthesis check complete.\n");
  
  //printf("Step 4: Outputting\n");
  command_stream_t cstream = (command_stream_t) checked_malloc(sizeof(struct command_stream));
  cstream->stream = buffer;
  cstream->index = 0;
  printf("Buffer: %s\n", buffer);
  
  return cstream;
}



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
    ////printf("%c",c);
    s->index=endptr - s->stream;
    ////printf("index: %d,len: %d\n",s->index,l);
    ////printf("cmd::: %.*s\n", endptr-start,start);
    return parseCmd(start,endptr-1);
  }
  return NULL;


}