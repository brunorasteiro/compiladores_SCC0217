%{
#include<stdio.h>
int yylex();
void yyerror(char* s);
void standard_error(char* expected, int obtained);
%}

%start programa

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

%token OP_IGUAL
%token OP_DIFERENTE
%token OP_MAIOR_IGUAL
%token OP_MENOR_IGUAL
%token OP_MAIOR
%token OP_MENOR
%token OP_ADICAO
%token OP_SUBTRACAO
%token OP_MULTIPLICACAO
%token OP_DIVISAO
%token OP_ATRIBUICAO
%token PONTO
%token VIRGULA
%token DOIS_PONTOS
%token PONTO_VIRGULA
%token ABRE_PARENTESES
%token FECHA_PARENTESES

%%
/* erros no <corpo> ficam para as regras dentro de corpo traterem */
programa : PROGRAM IDENT PONTO_VIRGULA corpo PONTO
        |  error  IDENT {printf("##########\n\n");} PONTO_VIRGULA corpo PONTO {yyerrok; yyclearin; standard_error("program", yychar);}
        |  PROGRAM error PONTO_VIRGULA corpo PONTO {yyerrok; yyclearin; printf("Erro: identificador esperado\n");}
        |  PROGRAM IDENT error corpo PONTO {yyerrok; yyclearin; printf("Erro: ';' esperado\n");}
        |  PROGRAM IDENT PONTO_VIRGULA corpo error {yyerrok; yyclearin; printf("Erro: '.' esperado\n");}
        |  error {printf("Erro: '.' esperado\n");}
        ;

corpo :   dc _BEGIN comandos END
        | dc error comandos END {yyerrok; yyclearin; printf("Erro: '.' esperado\n");}

        ;


dc : dc_c dc_v dc_p ;

dc_c : CONST IDENT OP_IGUAL numero PONTO_VIRGULA dc_c | ;

dc_v : VAR variaveis DOIS_PONTOS tipo_var PONTO_VIRGULA dc_v | ;

tipo_var : REAL | INTEGER ;

variaveis : IDENT mais_var ;

mais_var : VIRGULA variaveis | ;

dc_p : PROCEDURE IDENT parametros PONTO_VIRGULA corpo_p dc_p | ;

parametros : ABRE_PARENTESES lista_par FECHA_PARENTESES | ;

lista_par : variaveis DOIS_PONTOS tipo_var mais_par ;

mais_par : PONTO_VIRGULA lista_par | ;

corpo_p : dc_loc _BEGIN comandos END PONTO_VIRGULA ;

dc_loc : dc_v ;

lista_arg : ABRE_PARENTESES argumentos FECHA_PARENTESES | ;

argumentos : IDENT mais_ident ;

mais_ident : PONTO_VIRGULA argumentos | ;

pfalsa : ELSE cmd | ;

comandos : cmd PONTO_VIRGULA comandos
        |  cmd error comandos {yyerrok; printf("Erro: ';' esperado\n");}
        |
        ;

cmd : READ ABRE_PARENTESES variaveis FECHA_PARENTESES |
   WRITE ABRE_PARENTESES variaveis FECHA_PARENTESES |
   WHILE ABRE_PARENTESES condicao FECHA_PARENTESES DO cmd |
   IF condicao THEN cmd pfalsa |
   IDENT OP_ATRIBUICAO expressao |
   IDENT lista_arg |
   _BEGIN comandos END |
   FOR IDENT OP_ATRIBUICAO expressao TO expressao DO cmd ;

condicao : expressao relacao expressao ;

relacao : OP_IGUAL | OP_DIFERENTE | OP_MAIOR_IGUAL | OP_MENOR_IGUAL | OP_MENOR | OP_MAIOR ;

expressao : termo outros_termos ;

op_un : OP_ADICAO | OP_SUBTRACAO | ;

outros_termos : op_ad termo outros_termos | ;

op_ad : OP_ADICAO | OP_SUBTRACAO ;

termo : op_un fator mais_fatores ;

mais_fatores : op_mul fator mais_fatores | ;

op_mul : OP_MULTIPLICACAO | OP_DIVISAO ;

fator : IDENT | numero | ABRE_PARENTESES expressao FECHA_PARENTESES ;

numero : NUMERO_INT | NUMERO_REAL ;

%%

void main(){
	//printf("digite expr : \n");
	yyparse();
	// printf("expr válida \n");
	// int token;
    // while ((token = yylex()) != 0)
    // {
    //     printf("Token: %d\n", token);
    // }
    // return;
}

void yyerror(char* str){}

void standard_error(char* expected, int obtained){
    printf("Erro: Esperado '%s', obtido '%d'\n", expected, obtained);
}
