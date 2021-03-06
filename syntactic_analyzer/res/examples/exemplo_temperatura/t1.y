%{
#include <stdio.h>
#include <string.h>
%}

%token NUMERO CALOR ESTADO TEMPERATURA
%%

comandos: /* empty */
 		| comandos comando
 		;
comando:
 		interruptor
 		|
 		tempo
 		;
interruptor:
 		CALOR ESTADO
 		{
 			printf("\tCalor ligado ou desligado\n");
 		}
 		;
tempo:
 		TEMPERATURA NUMERO
 		{
			 printf("\tNova temperatura definida\n");
		}
		;

%%

void yyerror(const char *str)
{
	fprintf(stderr,"error: %s\n",str);
}	

int yywrap()
{
	return 1;
}

main()
{
	yyparse();
}
