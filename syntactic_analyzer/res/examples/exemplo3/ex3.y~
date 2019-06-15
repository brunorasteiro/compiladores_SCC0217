%{
#include<stdio.h>
#include<stdlib.h>
int valid=1;	
%}

%token A B NL
%%
stmt: A A A A A S B NL  {printf("string válida\n");
		exit(0);}
    ;
S:S A
 |
 ;
%%

main()
{
	printf("Insira a string:\n");
	yyparse();
}
yywrap(){}
yyerror()
{
	printf("Error\n");
}
