/* Exp04_b5_parser.l */
/* Author: Qin Hao */
/* Date: 2020/7 */

%{

#include "util.h"
#include "errormsg.h"
#include "parser.tab.h"

int charPos = 1;

int yywrap(void) {
    charPos = 1;
    return 1;
}

void refresh(void) {
    EM_tokPos = charPos;
    charPos += yyleng;
}

%}

delim		[ \t \n]
ws			{delim}+
letter		[A-Za-z]
digit		[0-9]
id			{letter}({letter}|{digit})*
number		{digit}+(\.{digit}+)?(E[+-]?{digit}+)?
integer	    {digit}+
real	    {digit}*\.{integer}
float       ({digit})*(\.{digit})({digit})*

/*多行注释*/
%s COMMENT
/*单行注释*/
%s SINGLELINECOMMENT

%%

 /* 多行注释 */
<INITIAL>"/*"			  {refresh(); BEGIN COMMENT;}
<COMMENT>"*/"			  {refresh(); BEGIN INITIAL;}
<COMMENT>.|\n			  {refresh();}

 /* 单行注释 */
<INITIAL>"//"			  {refresh(); BEGIN SINGLELINECOMMENT;}
<SINGLELINECOMMENT>\n	  {refresh(); BEGIN INITIAL;}
<SINGLELINECOMMENT>.	  {refresh();}

<INITIAL>PROGRAM          {refresh(); return (PROGRAM);}
<INITIAL>BEGIN            {refresh(); return (BEGINS);}
<INITIAL>END              {refresh(); return (END);}
<INITIAL>VAR              {refresh(); return (VAR);}

<INITIAL>INTEGER          {refresh(); return (INTEGER);}
<INITIAL>REAL             {refresh(); return (REAL);}

<INITIAL>IF               {refresh(); return (IF);}
<INITIAL>THEN             {refresh(); return (THEN);}
<INITIAL>ELSE             {refresh(); return (ELSE);}
<INITIAL>WHILE            {refresh(); return (WHILE);}
<INITIAL>DO               {refresh(); return (DO);}

<INITIAL>{ws}	          {refresh();}
<INITIAL>{integer}        {refresh(); yylval.ival = atoi(yytext); return (INT);}
<INITIAL>{float}          {refresh(); yylval.fval = atof(yytext); return (FLOAT);}
<INITIAL>{id}             {refresh(); yylval.sval = yytext; return (ID);}

<INITIAL>"+"              {refresh(); return (ADD);}
<INITIAL>"-"              {refresh(); return (SUBTRACT);}
<INITIAL>"*"              {refresh(); return (MULTIPLY);}
<INITIAL>"/"              {refresh(); return (DIVIDE);}

<INITIAL>"<"	          {refresh(); yylval.ival = LT; return (RELOP);}
<INITIAL>"<="	          {refresh(); yylval.ival = LE; return (RELOP);}
<INITIAL>"="	          {refresh(); yylval.ival = EQ; return (RELOP);}
<INITIAL>"<>"	          {refresh(); yylval.ival = NEQ; return (RELOP);}
<INITIAL>">"	          {refresh(); yylval.ival = GT; return (RELOP);}
<INITIAL>">="	          {refresh(); yylval.ival = GE; return (RELOP);}

<INITIAL>"("              {refresh(); return (LPARENTHESIS);}
<INITIAL>")"              {refresh(); return (RPARENTHESIS);}
<INITIAL>";"              {refresh(); return (SEMICOLON);}
<INITIAL>":"              {refresh(); return (COLON);}
<INITIAL>":="             {refresh(); return (ASSIGN);}
<INITIAL>","              {refresh(); return (COMMA);}
<INITIAL>"."              {refresh(); return (DOT);}

<INITIAL>\n               {refresh(); EM_newline();}
<INITIAL>.				  {printf("\nLEX:ERROR! c=%s\n", yytext);}

%%

void resetLexState() {
    BEGIN INITIAL;
}