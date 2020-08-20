%{
	#include <ctype.h>
	#include <stdio.h>
	int yylex();
	int yyerror(char* s);  /* yyerror 声明，使用库中的实现，为避免出现warning */
	#define YYSTYPE int /* 将Yacc栈定义为int类型 */
	#define YYDEBUG 1      /* 允许debug模式 */
%}

%token OR AND NOT TRUE FALSE LPAREN RPAREN ENTER

%%

/*
S->S or T | T
T->T and F | F
F->not F | (S) | false | true

*/

prog : prog exprp
		 | exprp
		 ;

exprp 	: s ENTER {printf("\nThe result of the bool expression is "); $1 == 0 ? printf("FALSE\n") : printf("TRUE\n");}

s: s OR t  {$$ = $1 || $3;}
	| t
	;

t: t AND f  {$$ = $1 && $3;}
	| f
	;

f: NOT f  {$$ = !$2;}
	| LPAREN s RPAREN  {$$ = $2;}
	| FALSE  {$$ = 0;}
	| TRUE  {$$ = 1;}
	;

%%

int main(int argc, char ** argv){
	//yydebug = 1;
	extern FILE* yyin;
	if (argc == 2){
	  if ((yyin = fopen(argv[1], "r")) == NULL){
	    printf("Can't open file %s\n", argv[1]);
	    return 1;
	  }
	}
	
	yyparse();

	if(argc == 2){
	  fclose(yyin);
	}

	return 0;
}
