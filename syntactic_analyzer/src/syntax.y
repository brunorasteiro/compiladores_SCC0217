%{
#include<stdio.h>
int yylex();
void yyerror(char* s);
%}

%union 
{
    int number;
    char *string;
}

%token _BEGIN
%token CONST
%token DO
%token ELSE
%token END
%token FOR
%token IDENT
%token IF
%token INTEGER
%token NUMERO_INT
%token NUMERO_REAL
%token PROCEDURE
%token PROGRAM
%token READ
%token REAL
%token THEN
%token TO
%token VAR
%token WHILE
%token WRITE

%left '+' '-'
%left '*' '/'



%%



programa : PROGRAM IDENT ';' corpo '.' ;

corpo : dc _BEGIN comandos END ;

dc : dc_c dc_v dc_p ;

dc_c : CONST IDENT '=' numero ';' dc_c | %empty ;

dc_v : VAR variaveis ':' tipo_var ';' dc_v | %empty ;

tipo_var : REAL | INTEGER ;

variaveis : IDENT mais_var ;

mais_var : ',' variaveis | %empty ;

dc_p : PROCEDURE IDENT parametros ';' corpo_p dc_p | %empty ;

parametros : '(' lista_par ')' | %empty ;

lista_par : variaveis ':' tipo_var mais_par ;

mais_par : ';' lista_par | %empty ;

corpo_p : dc_loc _BEGIN comandos END ';' ;

dc_loc : dc_v ;

lista_arg : '(' argumentos ')' | %empty ;

argumentos : IDENT mais_ident ;

mais_ident : ';' argumentos | %empty ;

pfalsa : ELSE cmd | %empty ;

comandos : cmd ';' comandos | %empty ;

cmd : READ '(' variaveis ')' |
   WRITE '(' variaveis ')' |
   WHILE '(' condicao ')' DO cmd |
   IF condicao THEN cmd pfalsa |
   IDENT ':''=' expressao |
   IDENT lista_arg |
   _BEGIN comandos END |
   FOR IDENT TO numero DO cmd ;

condicao : expressao relacao expressao {printf("condicao\n");};

relacao : '=' | '<''>' | '>''=' | '<''=' | '>' | '<' ;

expressao : termo outros_termos ;

op_un : '+' | '-' | %empty ;

outros_termos : op_ad termo outros_termos | %empty ;

op_ad : '+' | '-' ;

termo : op_un fator mais_fatores ;

mais_fatores : op_mul fator mais_fatores | %empty ;

op_mul : '*' | '/' ;

fator : IDENT | numero | '(' expressao ')' ;

numero : NUMERO_INT | NUMERO_REAL ;
 


%%



void yywrap(){}

void yyerror(char* str)
{
	printf("Error\n");  
}
void main()
{
	// printf("digite expr : \n");
	// yyparse();
	// printf("expr válida \n");
	int token;
    while ((token = yylex()) != 0) 
    {
        printf("Token: %d\n", token);
    }
    return;
}

