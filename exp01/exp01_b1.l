/* Exp01_b1 */
/* Author: Qin Hao */
/* Date: 2020/4/26 */
/* Update: 2020/5/9 */

%{

#include <stdio.h>
#define LT			1
#define	LE			2
#define GT			3
#define	GE			4
#define	EQ			5
#define NE			6

#define IF			16
#define ELSE		17
#define WHILE		18
#define	DO			19
#define ID          20
#define NUMBER      21
#define RELOP       22

#define ARIOP		23
#define SEMI		24
#define LBBRAK 		25
#define RBBRAK		26
#define LSBRAK  	27
#define RSBRAK  	28
#define ASSIGN		29

#define NEWLINE     30
#define ERRORCHAR   31

%}

delim		[ \t \n]
ws			{delim}+
letter		[A-Za-z_]
digit		[0-9]
id			{letter}({letter}|{digit})*
number		{digit}+(\.{digit}+)?(E[+-]?{digit}+)?

/* 状态（或条件）定义可以定义在这里
 * INITIAL是一个默认的状态，不需要定义
 */
/*多行注释*/
%s COMMENT
/*单行注释*/
%s SINGLELINECOMMENT

%%

<INITIAL>"/*"						{BEGIN COMMENT;}
<COMMENT>"*/"						{BEGIN INITIAL;}
<COMMENT>.|\n						{;}

<INITIAL>"//"						{BEGIN SINGLELINECOMMENT;}
<SINGLELINECOMMENT>\n				{BEGIN INITIAL;}
<SINGLELINECOMMENT>.				{;}
 /* 单行注释的情况和多行注释不同，// 后面不能出现 \n */

<INITIAL>"{"						{return (LBBRAK);}
<INITIAL>"}"						{return (RBBRAK);}

<INITIAL>"("						{return (LSBRAK);}
<INITIAL>")"						{return (RSBRAK);}

 /* ECHO是一个宏，相当于 fprintf(yyout, "%s", yytext)*/

<INITIAL>{ws}	          {;}
<INITIAL>while			  {return (WHILE);}
<INITIAL>do		          {return (DO);}
<INITIAL>if				  {return (IF);}
<INITIAL>else			  {return (ELSE);}
<INITIAL>{id}	          {return (ID);}
<INITIAL>{number}	      {return (NUMBER);}
<INITIAL>"<"	          {return (RELOP);}
<INITIAL>"<="	          {return (RELOP);}
<INITIAL>"=="	          {return (RELOP);}
<INITIAL>"!="	          {return (RELOP);}
<INITIAL>">"	          {return (RELOP);}
<INITIAL>">="	          {return (RELOP);}

<INITIAL>"="	          {return (ASSIGN);}
<INITIAL>";"			  {return (SEMI);}

<INITIAL>"+"			  {return (ARIOP);}
<INITIAL>"-"			  {return (ARIOP);}
<INITIAL>"*"			  {return (ARIOP);}
<INITIAL>"/"			  {return (ARIOP);}

<INITIAL>.				  {return ERRORCHAR;}

%%

int yywrap (){
  return 1;
}

void writeout(int c){
  switch(c) {
  	case ERRORCHAR: fprintf(yyout, "(ERRORCHAR, \"%s\") ", yytext);break;
  	case RELOP: fprintf(yyout, "(RELOP, \"%s\") ", yytext);break;
    case WHILE: fprintf(yyout, "(WHILE, \"%s\") ", yytext);break;
    case DO: fprintf(yyout, "(DO, \"%s\") ", yytext);break;
	case IF: fprintf(yyout, "(IF, \"%s\") ", yytext);break;
	case ELSE: fprintf(yyout, "(ELSE, \"%s\") ", yytext);break;
    case NUMBER: fprintf(yyout, "(NUM, \"%s\") ", yytext);break;
    case ID: fprintf(yyout, "(ID, \"%s\") ", yytext);break;
	case ARIOP: fprintf(yyout, "(ARIOP, \"%s\") ", yytext);break;
	case SEMI: fprintf(yyout, "(SEMI, \"%s\") ", yytext);break;
	case LBBRAK: fprintf(yyout, "(LBBRAK, \"%s\") ", yytext);break;
	case RBBRAK: fprintf(yyout, "(RBBRAK, \"%s\") ", yytext);break;
	case LSBRAK: fprintf(yyout, "(LSBRAK, \"%s\") ", yytext);break;
	case RSBRAK: fprintf(yyout, "(RSBRAK, \"%s\") ", yytext);break;
	case ASSIGN: fprintf(yyout, "(ASSIGN, \"%s\") ", yytext);break;
    case NEWLINE: fprintf(yyout, "\n");break;
    default:break;
  }
  return;
}

int main (int argc, char ** argv){
	int c,j=0;
	if (argc>=2){
	  if ((yyin = fopen(argv[1], "r")) == NULL){
	    printf("Can't open file %s\n", argv[1]);
	    return 1;
	  }
	  if (argc>=3){
	    yyout=fopen(argv[2], "w");
	  }
	}

	while (c = yylex()){
		writeout(c);
		j++;
		if (j%5 == 0) writeout(NEWLINE);
	}
	if(argc>=2){
	  fclose(yyin);
	  if (argc>=3) fclose(yyout);
	}
	return 0;
}
