/* 把讨厌的注释去掉 */

%{
 
#include "cal.tab.h"
/*
yylval在cal.y中进行定义，不需要在此文件中再次定义
*/
%}

ws			[ \t]
digit		[0-9]
number		{digit}+(\.{digit}+)?

%%

 /* ECHO是一个宏，相当于 fprintf(yyout, "%s", yytext)*/
<INITIAL>or					{ return (OR);}
<INITIAL>and					{ return (AND);}
<INITIAL>not					{ return (NOT);}
<INITIAL>true					{ return (TRUE);}
<INITIAL>false					{ return (FALSE);}
<INITIAL>"("					{ return (LPAREN);}
<INITIAL>")"					{ return (RPAREN);}
{ws}							{;}
<INITIAL>"\n"					{ return (ENTER);}
.								{printf("\nLEX:ERROR! c=%s\n", yytext);}
