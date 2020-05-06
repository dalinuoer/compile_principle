/* Exp02_b2 */
/* Author: Qin Hao */
/* Date: 2020/5/6 */

%{

#include <stdio.h>

#define PROGRAM         1
#define SEMICOLON       2
#define BEGIN           3
#define END             4
#define DOT             5
#define VAR             6
#define COLON           7
#define INTEGER         8
#define REAL            9
#define COMMA           10
#define ASSIGN          11
#define IF              12
#define THEN            13
#define ELSE            14
#define WHILE           15
#define DO              16
#define ADD             17
#define SUBTRACT        18
#define MULTIPLY        19
#define DIVIDE          20
#define LPARENTHESIS    21
#define RPARENTHESIS    22
#define LT              23
#define	LE              24
#define GT              25
#define	GE              26
#define	EQ              27
#define NE              28
#define ID              29
#define NUMINTEGER      30
#define NUMREAL         31
#define RELOP           32
#define NEWLINE         33
#define ERRORCHAR       34

%}

delim		[ \t \n]
ws			{delim}+
letter		[A-Za-z]
digit		[0-9]
id			{letter}({letter}|{digit})*
number		{digit}+(\.{digit}+)?(E[+-]?{digit}+)?
integer	    {digit}+
real	    {digit}*\.{integer}

/*多行注释*/
%s COMMENT
/*单行注释*/
%s SINGLELINECOMMENT

%%

<INITIAL>"/*"			  {BEGIN COMMENT;}
<COMMENT>"*/"			  {BEGIN INITIAL;}
<COMMENT>.|\n			  {;}

 /* 单行注释的情况和多行注释不同，// 后面不能出现 \n */
<INITIAL>"//"			  {BEGIN SINGLELINECOMMENT;}
<SINGLELINECOMMENT>\n	  {BEGIN INITIAL;}
<SINGLELINECOMMENT>.	  {;}

<INITIAL>PROGRAM          {return (PROGRAM);}
<INITIAL>BEGIN            {return (BEGINS);}
<INITIAL>END              {return (END);}
<INITIAL>VAR              {return (VAR);}

<INITIAL>INTEGER          {return (INTEGER);}
<INITIAL>REAL             {return (REAL);}

<INITIAL>{ws}	          {;}
<INITIAL>{integer}        {return (NUMINTEGER);}
<INITIAL>{real}           {return (NUMREAL);}
<INITIAL>{id}             {return (ID);}

<INITIAL>IF               {return (IF);}
<INITIAL>THEN             {return (THEN);}
<INITIAL>ELSE             {return (ELSE);}
<INITIAL>WHILE            {return (WHILE);}
<INITIAL>DO               {return (DO);}

<INITIAL>"+"              {return (ADD);}
<INITIAL>"-"              {return (SUBTRACT);}
<INITIAL>"*"              {return (MULTIPLY);}
<INITIAL>"/"              {return (DIVIDE);}

<INITIAL>"<"	          {return (RELOP);}
<INITIAL>"<="	          {return (RELOP);}
<INITIAL>"="	          {return (RELOP);}
<INITIAL>"<>"	          {return (RELOP);}
<INITIAL>">"	          {return (RELOP);}
<INITIAL>">="	          {return (RELOP);}

<INITIAL>"("              {return (LPARENTHESES);}
<INITIAL>")"              {return (RPARENTHESES);}
<INITIAL>";"              {return (SEMICOLON);}
<INITIAL>":"              {return (COLON);}
<INITIAL>":="             {return (ASSIGN);}
<INITIAL>","              {return (COMMA);}
<INITIAL>"."              {return (DOT);}

<INITIAL>.				  {return (ERRORCHAR);}

%%

int yywrap() {
  return 1;
}

void writeout(int c) {
  switch(c) {
	case PROGRAM: fprintf(yyout, "(PROGRAM, \"%s\") ", yytext); break;
	case BEGIN: fprintf(yyout, "(BEGIN, \"%s\") ", yytext); break;
    case END: fprintf(yyout, "(END, \"%s\") ", yytext); break;
	case VAR: fprintf(yyout, "(VAR, \"%s\") ", yytext);break;

	case INTEGER: fprintf(yyout, "(INTEGER, \"%s\") ", yytext); break;
    case REAL: fprintf(yyout, "(REAL, \"%s\") ", yytext); break;

	case NUMINTEGER: fprintf(yyout, "(Integer, %d) ", yytext); break;
    case NUMREAL: fprintf(yyout, "(Real, %f) ", yytext); break;
    case ID: fprintf(yyout, "(ID, \"%s\") ", yytext); break;

	case IF: fprintf(yyout, "(IF, \"%s\") ", yytext); break;
	case THEN: fprintf(yyout, "(THEN, \"%s\") ", yytext); break;
	case ELSE: fprintf(yyout, "(ELSE, \"%s\") ", yytext); break;
	case WHILE: fprintf(yyout, "(WHILE, \"%s\") ", yytext); break;
    case DO: fprintf(yyout, "(DO, \"%s\") ", yytext); break;

	case ADD: fprintf(yyout, "(ADD, \"%s\") ", yytext); break;
    case SUBTRACT: fprintf(yyout, "(SUBTRACT, \"%s\") ", yytext); break;
    case MULTIPLY: fprintf(yyout, "(MULTIPLY, \"%s\") ", yytext); break;
    case DIVIDE: fprintf(yyout, "(DIVIDE, \"%s\") ", yytext); break;

  	case RELOP: fprintf(yyout, "(RELOP, \"%s\") ", yytext);xbreak;

	case LPARENTHESES: fprintf(yyout, "(LPAR, \"%s\") ", yytext); break;
    case RPARENTHESES: fprintf(yyout, "(RPAR, \"%s\") ", yytext); break;
	case SEMICOLON: fprintf(yyout, "(SEMI, \"%s\") ", yytext); break;
	case COLON: fprintf(yyout, "(COLON, \"%s\") ", yytext); break;
	case ASSIGN: fprintf(yyout, "(ASSIGN, \"%s\") ", yytext); break;
    case COMMA: fprintf(yyout, "(COMMA, \"%s\") ", yytext); break;
	case DOT: fprintf(yyout, "(DOT, \"%s\") ", yytext); break;

    case NEWLINE: fprintf(yyout, "\n"); break;
	case ERRORCHAR: fprintf(yyout, "(ERRORCHAR, \"%s\") ", yytext); break;

    default:break;
  }
  return;
}

int main (int argc, char ** argv) {
	int c, j = 0;
	if (argc >= 2) {
	  if ((yyin = fopen(argv[1], "r")) == NULL) {
	    printf("Can't open file %s\n", argv[1]);
	    return 1;
	  }
	  if (argc >= 3) {
	    yyout=fopen(argv[2], "w");
	  }
	}

	while (c = yylex()) {
		writeout(c);
		j++;
		if (j%5 == 0) writeout(NEWLINE);
	}
	if(argc >= 2) {
	  fclose(yyin);
	  if (argc >= 3) fclose(yyout);
	}
	return 0;
}
