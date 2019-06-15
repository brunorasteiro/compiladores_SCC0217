%{
#include<stdio.h>
int valid=1;	
%}

%token A B
%%
str: S'\n' {return 0;}
S:A S B
 |
 ;
%%
main()
{
	printf("Insira a string:\n");
	yyparse();
	if(valid ==1)
	printf("string válida\n");
}
yywrap(){}
yyerror()
{
	printf("Error\n");
}
