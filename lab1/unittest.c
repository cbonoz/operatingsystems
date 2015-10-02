#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void 
parseCmd(char *str) {
  char * pch;
  //printf ("Splitting string \"%s\" into tokens:\n",str);
  pch = strtok (str," ,.-");
  while (pch != NULL)
  {
    printf ("%s\n",pch);
    pch = strtok (NULL, " ,.-");
  }
}




int main ()
{
  char s[]="daskflafh4w0fh-a0h0h4w0,,|h00";
  parseCmd(s);
  
  return 0;
}