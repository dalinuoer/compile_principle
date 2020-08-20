%{
	#include <ctype.h>
	#include <stdio.h>
	int yylex();
	int yyerror(char* s);  /* yyerror 声明，使用库中的实现，为避免出现warning */
	#define YYSTYPE int /* 将Yacc栈定义为int类型 */
	#define YYDEBUG 1      /* 允许debug模式 */
%}


%token TRUE FALSE LPAREN RPAREN ENTER
%left OR
%left AND
%right NOT

%%

/*
S –> S or S | S and S | not S | (S) | true | false
*/

prog : prog exprp
		 | exprp
		 ;

exprp 	: s ENTER {printf("\nThe result of the bool expression is "); $1 == 0 ? printf("FALSE\n") : printf("TRUE\n");}

s : s OR s  {$$ = $1 || $3;}
		|s AND s  {$$ = $1 && $3;}
		|NOT s  {$$ = !$2;}
		|LPAREN s RPAREN  {$$ = $2;}
		|TRUE  {$$ = 1;}
		|FALSE  {$$ = 0;}
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
