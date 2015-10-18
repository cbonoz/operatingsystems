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

/*
isWordChar returns false for spaces
*/
bool
isWordChar(char c) {
  return isalnum(c) || isSpecial(c);
}

 char *
 skipWs(char *ptr) {
  while (*ptr==' ' || *ptr == '\t' || *ptr == '\n')
    ptr++;
  return ptr;
  //return ptr;
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
findSplitOperator
@param ptr pointer to start of str
@return ptr to end of string if no non-subshell operator is found, 
  otherwise pointer to lowest precendencenon-subshell operator
*/
char *
findNextOperator(char *ptr, char *end) {
  ptr=skipWs(ptr);
  if (*ptr=='(') { //opening of subshell
    
    int openparen=1;
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
  char *op=strpbrk(ptr,";$*|");
  return op;
  
}

char *
skipSubshell(char *ptr) {
  ptr=skipWs(ptr);
  ////printf("skipSubshell - after skipW: %s\n", ptr);
  if (*ptr=='(') { //opening of subshell
    //subshell=true;
    int openparen=1;
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
  //if(ptr!='\0')
  //  ptr++;
  ////printf("skipSubshell - after skipS: %s\n", ptr);
  //char *op = strpbrk(ptr,";$*|");
  ////printf("findNextOperator: %c\n", *op);
  return ptr;
  
}
/*
parseCmd
@param start - pointer to command string start
@param end - pointer to command string end
@return command_t - pointer to allocated memory with the defined/parsed command
*/

char * currWordEnd(char* ptr, char* end)
{
  while (ptr <= end && !(*ptr == ' ' || *ptr == '\t' || *ptr == '<' || *ptr == '>'))
  {
    ptr++;
  }
  return ptr-1;
}

//returns NULL if no additional word is found before end
char * nextWordStart(char* ptr, char* end)
{
  ptr++;
  while (ptr <= end && (*ptr == ' ' || *ptr == '\t'))
  {
    ptr++;
  }
  return ptr <= end ? ptr : NULL;
}

//precondition: start is pointing to a redirection symbol
//return the last char of the input/output redirection
char * ioRedirection(char * start, char * end, command_t t)
{
    char * s = nextWordStart(start, end);
    char * e = currWordEnd(s, end);
    size_t wsize = e-s+1;
    if(*start == '<')
    {
      t->input=(char *) checked_malloc(wsize+1);
      memcpy(t->input,s,wsize);
      t->input[wsize]='\0';
      //if(debug) printf("Building segments: \"%.*s\" -> \'%s\'\n", e-s+1, s, t->input);
      
    }
    else
    {
      t->output=(char *) checked_malloc(wsize+1);
      memcpy(t->output,s,wsize);
      t->output[wsize]='\0';
      //if(debug) printf("Building segments: \"%.*s\" -> \'%s\'\n", e-s+1, s, t->output);
    }
    return e;
}       


command_t 
parseCmd(char *start, char *end) {
  if (start>end || iters++>MAXITER) return NULL;
  
  //trim the start and end pointers
  start=skipWs(start);

  if (*start=='\0') return NULL;
  while (*end == ' ' || *end == '\t' || *end == '\n')
  {
    end--;
  }

  //if (debug) printf("parsing: \"%.*s\" start = \'%c\' end = \'%c\'\n", end-start+1, start, *start, *end);

  command_t t = (command_t) checked_malloc(sizeof(struct command));
  char *ptr = start;
  //char *op = findNextOperator(ptr);
  char *op = strpbrk(skipSubshell(ptr), ";$*|");
  char *next = op;
  
  ////printf("parsing: start = %c op = %c next = %c \n", *ptr, *op, *next);
  
  while (next && next <= end) { 
    
    char * prec = ";$*|";
    int opPrec = strchr(prec, *op) - prec;
    int nextPrec = strchr(prec, *next) - prec;
    //printf("parsing: [while] opPrec = %d nextPrec = %d \n", opPrec, nextPrec);
    if (((opPrec == 1 || opPrec == 2) && (nextPrec == 1 || nextPrec == 2))
      || (nextPrec < opPrec))
    {
      op = next;
    }        
    //printf("parsing: [while] start = %c op = %c next = %c \n", *ptr, *op, *next);
    //next = findNextOperator(++next);
    next = strpbrk(skipSubshell(++next), ";$*|");
    
  }
  
  if (op && op<end) { // if operator in expression
      //////printf("op: %c\n",*op);
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
      //printf("\ncomplex command type%d: %.*s,%.*s\n", t->type, op-start, start,end-op,op+1);
      //t->u.command=(command_t *) checked_malloc(sizeof(command_t)*2);
      t->status = -1;
      //t->input = "0";
      //t->output = "0";
      t->u.command[0]=parseCmd(start,op-1);
      t->u.command[1]=parseCmd(op+1,end);
      
    
  } else if (*start == '(') { //if subshell
      //printf("subshell command\n");
      ptr = skipSubshell(ptr);
      t->type=SUBSHELL_COMMAND;
      t->status = -1;
      t->u.subshell_command=(command_t) checked_malloc(sizeof(command_t));
      t->u.subshell_command=parseCmd(start+1,ptr-1);
      //ptr = skipWs(++ptr);
      
      while(ptr)
      {
        if (*ptr == '<' || *ptr == '>')
        {
          ptr = ioRedirection(ptr, end, t);
        }
        // if(*ptr == '<')
        // {
        //   ptr = nextWordStart(ptr, end);
        //   size_t wsize = currWordEnd(ptr, end)-ptr+1;
        //   t->input=(char *) checked_malloc(wsize+1);
        //   memcpy(t->input,ptr,wsize);
        //   t->input[wsize]='\0';
        //   //if(debug) printf("Building segments: \"%.*s\" -> \'%s\'\n", e-s+1, s, t->input);
          
        // }
        // else if(*ptr == '>')
        // {
        //   ptr = nextWordStart(ptr, end);
        //   size_t wsize = currWordEnd(ptr, end)-ptr+1;
        //   t->output=(char *) checked_malloc(wsize+1);
        //   memcpy(t->output,ptr,wsize);
        //   t->output[wsize]='\0';
        //   //if(debug) printf("Building segments: \"%.*s\" -> \'%s\'\n", e-s+1, s, t->output);
        // }
        ptr = nextWordStart(ptr, end);
      }
      

  } else { //simple command with no op and no subshell
    //if (debug) printf("Building simple command\n");
      t->type=SIMPLE_COMMAND;

      int wdct=0;//word count tracker

      //construct the simple command struct from str - check for redirections
      char* s = start;
      char* e;

      while (s)
      { 
        if (*s == '<' || *s == '>')
        {
          s = ioRedirection(s, end, t);
        }
        // if(*s == '<')
        // {
        //  s = nextWordStart(s, end);
        //  e = currWordEnd(s, end);
        //  size_t wsize = e-s+1;
        //  t->input=(char *) checked_malloc(wsize+1);
        //  memcpy(t->input,s,wsize);
        //  t->input[wsize]='\0';
        //  //if(debug) printf("Building segments: \"%.*s\" -> \'%s\'\n", e-s+1, s, t->input);
          
        // }
        // else if(*s == '>')
        // {
        //  s = nextWordStart(s, end);
        //  e = currWordEnd(s, end);
        //  size_t wsize = e-s+1;
        //  t->output=(char *) checked_malloc(wsize+1);
        //  memcpy(t->output,s,wsize);
        //  t->output[wsize]='\0';
        //  //if(debug) printf("Building segments: \"%.*s\" -> \'%s\'\n", e-s+1, s, t->output);
        // }
        else
        {
          e = currWordEnd(s, end);
          size_t wsize = e-s+1;
          size_t asize = sizeof(char*) * (wdct+2);
          t->u.word = (char **) checked_realloc(t->u.word, asize);
          t->u.word[wdct] = (char *) checked_malloc(wsize+1);
          memcpy(t->u.word[wdct],s,wsize);
          t->u.word[wdct][wsize]='\0';
          wdct++; 
          s = e;
          //if(debug) printf("Building segments: \"%.*s\" -> \'%s\'\n", e-s+1, s, t->u.word[wdct-1]);
        }
        s = nextWordStart(s, end);
      }
    *(t->u.word+wdct)=NULL;    
    }
  return t;
}

command_stream_t
make_command_stream(int (*get_next_byte) (void *),
         void *get_next_byte_argument)
{
  
  //building the stream string
  int lineNum = 1;
  
  ////printf("Step 1: Building the buffer string.\n");
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
  ////printf("Step 1: Buffer Built \n%s\n Strlen(buffer) = %d, bufferSize = %d\n", buffer, strlen(buffer), bufferSize);
  
  
  ////printf("Step 2: Clean up iteration started.\n");
  lineNum = 1;
  int prev = -1;
  int n; //next nonwhite space index
  int curr = nextIndex(buffer, bufferSize, -1);
  int next = nextIndex(buffer, bufferSize, curr);
  while (curr < bufferSize)
  {
    ////printf("Step 2: prev = %d, curr = %d, next = %d.\n", prev, curr, next);
    switch (buffer[curr])
    {
      case ';':
        n = nextNonwhitespace(buffer, bufferSize, curr);
        if ((prev==-1) || (n == bufferSize) 
          || !(isWordChar(buffer[prev])||buffer[prev] == ')')  //(;) );(
          || !(isWordChar(buffer[n])||buffer[n] == '('))
        {
          error(1,0,"%d: Syntax error (Incomplete operators %c found)\n", lineNum, buffer[curr]);
        }
        break;
      case '>':
      case '<':
        //if ((prev==-1) || (nextNonwhitespace(buffer, bufferSize, curr) == bufferSize)
        //  ||(isOperator(buffer[prev])) || (isOperator(buffer[next])))
        if ((prev==-1) || (nextNonwhitespace(buffer, bufferSize, curr) == bufferSize) 
          || !(isWordChar(buffer[prev])||buffer[prev]==')') || !isWordChar(buffer[next]))
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
          n = nextNonwhitespace(buffer, bufferSize, curr);
          if ((prev==-1) || (n==bufferSize)
            || !(isWordChar(buffer[prev])||buffer[prev] == ')')  //(;) );(
          || !(isWordChar(buffer[n])||buffer[n] == '('))
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
         n = nextNonwhitespace(buffer, bufferSize, curr);
        if ((prev==-1) || (n==bufferSize)
          || !(isWordChar(buffer[prev])||buffer[prev] == ')')  //(;) );(
          || !(isWordChar(buffer[n])||buffer[n] == '('))
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
  ////printf("Step 2: Buffer cleaned \n%s\n Strlen(buffer) = %d, bufferSize = %d\n", buffer, strlen(buffer), bufferSize);
  
  ////printf("Step 3: Parenthesis check start.\n");
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
  ////printf("Step 3: Parenthesis check complete.\n");
  
  ////printf("Step 4: Outputting\n");
  command_stream_t cstream = (command_stream_t) checked_malloc(sizeof(struct command_stream));
  cstream->stream = buffer;
  cstream->index = 0;
  if (debug) printf("Buffer: \"%s\"\n", buffer);
  
  return cstream;
}

static int j=0;

command_t
read_command_stream (command_stream_t s)
{
  
  //int l=strlen(s->stream);
  char *start=s->stream+s->index;
  
  if (*start==ENDCHAR) {
    s->index=s->index+1;
    start++;
  }

  char *endptr=start;
  char c=*endptr;
  while (c != ENDCHAR && c != '\0')
      c=*++endptr;
  //////printf("%c",c);
  s->index=endptr - s->stream;
  //////printf("index: %d,len: %d\n",s->index,l);
  //if(debug) printf("read_stream %d(index,l) (%d, %d)::: \"%.*s\"\n", j++,s->index,l,endptr-start,start);
  return start<endptr ? parseCmd(start,endptr-1) : NULL;
}