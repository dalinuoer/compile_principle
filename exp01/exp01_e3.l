%{



#include <stdio.h>

#define STRING  1

#define NOT     2

#define FLOAT	3

#define OTHER 	4



%}



delim		[ \t \n]

ws			{delim}+



%%


<INITIAL>\".*\"         {return (STRING);}

<INITIAL>[^{ws}]        {return (NOT);}

<INITIAL>float/[ \t]+   {return (FLOAT);}

<INITIAL>\n|.           {return (OTHER);}

%%



int yywrap () {

  return 1;

}



void writeout(int c) {

  switch(c) {

	case STRING: fprintf(yyout, "%s", yytext); break;
	
	case NOT: fprintf(yyout, "%s", yytext); break;

    case FLOAT: fprintf(yyout, "double"); break;

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