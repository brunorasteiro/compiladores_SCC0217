%{
#include<stdio.h>	
%}
%token ID NUMBER
%left '+' '-'
%left '*' '/'
%%
stmt:expr
	;
expr: expr '+' expr
	| expr '-' expr
	| expr '*' expr
	| expr '/' expr
	| '(' expr ')'
	| NUMBER
	| ID
	;
%%
void main()
{
	printf("digite expr : \n");
	yyparse();
	printf("expr válida \n");
}
yywrap(){}
yyerror()
{
	printf("Error\n");
}
