/* Exp01_e2 */
/* Author: Qin Hao */
/* Date: 2020/4/26 */

%{

#include <stdio.h>

#define BLANK 	1
#define OTHER 	2

%}

delim		[ \t \n]
ws			{delim}+
other		[^{ws}]

%%

<INITIAL>{ws} 			{return (BLANK);}
<INITIAL>{other}		{return (OTHER);}

%%

int yywrap () {
  return 1;
}

void writeout(int c) {
  switch(c) {
    case BLANK: fprintf(yyout, " "); break;
    case OTHER: fprintf(yyout, "%s", yytext); break;
    default: break;
  }
  return;
}

int main (int argc, char ** argv) {
	int c;
	if (argc >= 2) {
	  if ((yyin = fopen(argv[1], "r")) == NULL) {
	    printf("Can't open file %s\n", argv[1]);
	    return 1;
	  }
	  if (argc >= 3) {
	    yyout = fopen(argv[2], "w");
	  }
	}

	while (c = yylex()) {
		writeout(c);
	}

	if(argc >= 2) {
	  fclose(yyin);
	  if (argc>=3) fclose(yyout);
	}

	return 0;
}
