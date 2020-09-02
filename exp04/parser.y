/* Exp04_b5_parser.y */
/* Author: Qin Hao */
/* Date: 2020/7 */

%{

#include <stdio.h>
#include "util.h" 
#include "errormsg.h"

int yylex(void); /* function prototype */

/* 该函数显示错误信息s，显示时包含了错误发生的位置。*/
void yyerror(char *s) {
    EM_error(EM_tokPos, "%s", s);
}

%}

 /* 定义属性值栈的类型，后续实验中如果需要存储不同类型的属性值，则需要修改此处 */
%union {
    int ival;
    double fval;
    string sval;
}

 /* 定义各个终结符，以及他们的属性值的类型，后续实验中如果需要存储不同类型的属性值，则需要修改此处 */
%token <sval> ID /* id */
%token <ival> INT RELOP /*整型数*/
%token <fval> FLOAT /*浮点数*/

%token 
    INTEGER REAL  /*两种类型名：整型、实型*/
    COMMA COLON SEMICOLON LPARENTHESIS RPARENTHESIS DOT /* 符号 , : ; ( ) . */
    PROGRAM BEGINS END VAR IF WHILE DO   /* 关键字：PROGRAM BEGIN END VAR IF WHILE DO */
    THEN ELSE /* 关键字：THEN ELSE */
    ASSIGN EQ NEQ LT LE GT GE /* 符号 := = <> < <= > >= */
    ADD SUBTRACT MULTIPLY DIVIDE /* 符号 + = * / */

%start program /* 开始符号为program */

%debug /* 允许跟踪错误 */

%%

 /* <程序> --> PROGRAM <标识符> ; <分程序> */
 /* <分程序> --> <变量说明> BEGIN <语句表> END. */
program: PROGRAM ID SEMICOLON vardec BEGINS stmts END DOT
    ;

 /* <变量说明> --> VAR <变量说明表>; */
vardec: VAR declist 
    ;

 /* <变量说明表> --> <变量表>: <类型> | <变量表>: <类型>; <变量说明表> */
declist: varlist COLON type SEMICOLON
    | varlist COLON type SEMICOLON declist
    ;

 /* <类型> --> INTEGER | REAL */
type: INTEGER
    | REAL
    ;

 /* <变量表> --> <变量> | <变量>, <变量表> */
varlist: ID
    | ID COMMA varlist
    ;

 /* <语句表> --> <语句> | <语句>; <语句表> */
stmts: stmt 
    | stmt SEMICOLON stmts
    ;

 /* <语句> --> <赋值语句> | <条件语句> | <WHILE语句> | <复合语句> 
    <赋值语句> --> <变量> := <算术表达式>
    <条件语句> --> IF <关系表达式> THEN <语句> ELSE <语句>
    <WHILE语句> --> WHILE <关系表达式> DO <语句>
    <复合语句> --> BEGIN <语句表> END */
stmt: ID ASSIGN arith_exp
    | IF rel_exp THEN stmt ELSE stmt
    | WHILE rel_exp DO stmt
    | BEGINS stmts END 
    ;

 /* <算术表达式> --> <项> | <算术表达式> + <项> | <算术表达式> - <项> */
arith_exp: term 
    | arith_exp ADD term
    | arith_exp SUBTRACT term
    ;

 /* <项> --> <因式> | <项> * <因式> | <项> / <因式> */
term: factor 
    | term MULTIPLY factor 
    | term DIVIDE factor
    ;

 /* <因式> --> <变量> | <常数> | (<算术表达式>) */
factor: ID
    | constant
    | LPARENTHESIS arith_exp RPARENTHESIS
    ;

 /* <关系表达式> --> <算术表达式> <关系符> <算术表达式> */
rel_exp: arith_exp RELOP arith_exp
    ;

 /* <常数> --> <整数> | <浮点数> */
constant: INT
    | FLOAT
    ;

%%