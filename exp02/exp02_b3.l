/* Exp02_b3 */
/* Author: Qu Shaowei */
/* Date: 2020/5/8 */

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

union{
	char* sval;
	int   ival;
	float fval;
}yylval;

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

<INITIAL>PROGRAM          {yylval.sval=yytext;return (PROGRAM);}
<INITIAL>BEGIN            {yylval.sval=yytext;return (BEGIN);}
<INITIAL>END              {yylval.sval=yytext;return (END);}
<INITIAL>VAR              {yylval.sval=yytext;return (VAR);}

<INITIAL>INTEGER          {yylval.sval=yytext;return (INTEGER);}
<INITIAL>REAL             {yylval.sval=yytext;return (REAL);}

<INITIAL>IF               {yylval.sval=yytext;return (IF);}
<INITIAL>THEN             {yylval.sval=yytext;return (THEN);}
<INITIAL>ELSE             {yylval.sval=yytext;return (ELSE);}
<INITIAL>WHILE            {yylval.sval=yytext;return (WHILE);}
<INITIAL>DO               {yylval.sval=yytext;return (DO);}

<INITIAL>{ws}	          {;}
<INITIAL>{integer}        {yylval.ival=atoi(yytext);return (NUMINTEGER);}
<INITIAL>{real}           {yylval.fval=atof(yytext);return (NUMREAL);}
<INITIAL>{id}             {yylval.sval=yytext;return (ID);}

<INITIAL>"+"              {yylval.sval=yytext;return (ADD);}
<INITIAL>"-"              {yylval.sval=yytext;return (SUBTRACT);}
<INITIAL>"*"              {yylval.sval=yytext;return (MULTIPLY);}
<INITIAL>"/"              {yylval.sval=yytext;return (DIVIDE);}

<INITIAL>"<"	          {yylval.sval=yytext;return (RELOP);}
<INITIAL>"<="	          {yylval.sval=yytext;return (RELOP);}
<INITIAL>"="	          {yylval.sval=yytext;return (RELOP);}
<INITIAL>"<>"	          {yylval.sval=yytext;return (RELOP);}
<INITIAL>">"	          {yylval.sval=yytext;return (RELOP);}
<INITIAL>">="	          {yylval.sval=yytext;return (RELOP);}

<INITIAL>"("              {yylval.sval=yytext;return (LPARENTHESIS);}
<INITIAL>")"              {yylval.sval=yytext;return (RPARENTHESIS);}
<INITIAL>";"              {yylval.sval=yytext;return (SEMICOLON);}
<INITIAL>":"              {yylval.sval=yytext;return (COLON);}
<INITIAL>":="             {yylval.sval=yytext;return (ASSIGN);}
<INITIAL>","              {yylval.sval=yytext;return (COMMA);}
<INITIAL>"."              {yylval.sval=yytext;return (DOT);}

<INITIAL>.				  {yylval.sval=yytext;return (ERRORCHAR);}

%%

int yywrap() {
  return 1;
}

void writeout(int c) {
  switch(c) {
	case PROGRAM: fprintf(yyout, "(PROGRAM, \"%s\") ", yylval.sval); break;
	case BEGIN: fprintf(yyout, "(BEGIN, \"%s\") ", yylval.sval); break;
    case END: fprintf(yyout, "(END, \"%s\") ", yylval.sval); break;
	case VAR: fprintf(yyout, "(VAR, \"%s\") ", yylval.sval);break;

	case INTEGER: fprintf(yyout, "(INTEGER, \"%s\") ", yylval.sval); break;
    case REAL: fprintf(yyout, "(REAL, \"%s\") ", yylval.sval); break;

	case NUMINTEGER: fprintf(yyout, "(Integer, %d) ", yylval.ival); break;
    case NUMREAL: fprintf(yyout, "(Real, %f) ", yylval.fval); break;
    case ID: fprintf(yyout, "(ID, \"%s\") ", yylval.sval); break;

	case IF: fprintf(yyout, "(IF, \"%s\") ", yylval.sval); break;
	case THEN: fprintf(yyout, "(THEN, \"%s\") ", yylval.sval); break;
	case ELSE: fprintf(yyout, "(ELSE, \"%s\") ", yylval.sval); break;
	case WHILE: fprintf(yyout, "(WHILE, \"%s\") ", yylval.sval); break;
    case DO: fprintf(yyout, "(DO, \"%s\") ", yylval.sval); break;

	case ADD: fprintf(yyout, "(ADD, \"%s\") ", yylval.sval); break;
    case SUBTRACT: fprintf(yyout, "(SUBTRACT, \"%s\") ", yylval.sval); break;
    case MULTIPLY: fprintf(yyout, "(MULTIPLY, \"%s\") ", yylval.sval); break;
    case DIVIDE: fprintf(yyout, "(DIVIDE, \"%s\") ", yylval.sval); break;

  	case RELOP: fprintf(yyout, "(RELOP, \"%s\") ", yylval.sval);break;

	case LPARENTHESIS: fprintf(yyout, "(LPAR, \"%s\") ", yylval.sval); break;
    case RPARENTHESIS: fprintf(yyout, "(RPAR, \"%s\") ", yylval.sval); break;
	case SEMICOLON: fprintf(yyout, "(SEMI, \"%s\") ", yylval.sval); break;
	case COLON: fprintf(yyout, "(COLON, \"%s\") ", yylval.sval); break;
	case ASSIGN: fprintf(yyout, "(ASSIGN, \"%s\") ", yylval.sval); break;
    case COMMA: fprintf(yyout, "(COMMA, \"%s\") ", yylval.sval); break;
	case DOT: fprintf(yyout, "(DOT, \"%s\") ", yylval.sval); break;

    case NEWLINE: fprintf(yyout, "\n"); break;
	case ERRORCHAR: fprintf(yyout, "(ERRORCHAR, \"%s\") ", yylval.sval); break;

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
