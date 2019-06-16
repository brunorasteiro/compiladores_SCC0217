%{/* Prologue */

#include <stdio.h>
#include <string.h>
extern FILE* yyin;
extern int yydebug;
extern int yylex();
void yyerror(char* s);
// void standard_error(char* expected, int obtained);

%} /* Bison Declarations */

%start programa

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
%token OP_ASSIGN  ":="
%token OP_DIFF    "<>"
%token OP_GE      ">="
%token OP_LE      "<="

%% /* Grammar Rules */

/* erros no <corpo> ficam para as regras dentro de corpo traterem */
programa : PROGRAM IDENT ';' corpo '.' ;

corpo :   dc _BEGIN comandos END ;


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
   IDENT ":=" expressao |
   IDENT lista_arg |
   _BEGIN comandos END |
   FOR IDENT ":=" expressao TO expressao DO cmd ;

condicao : expressao relacao expressao ;

relacao : '=' | "<>" | ">=" | "<=" | '<' | '>' ;

expressao : termo outros_termos ;

op_un : '+' | '-' | %empty ;

outros_termos : op_ad termo outros_termos | %empty ;

op_ad : '+' | '-' ;

termo : op_un fator mais_fatores ;

mais_fatores : op_mul fator mais_fatores | %empty ;

op_mul : '*' | '/' ;

fator : IDENT | numero | '(' expressao ')' ;

numero : NUMERO_INT | NUMERO_REAL ;

%% /* Epilogue */

void yyerror(char* msg) {
  fprintf(stderr, "%s\n", msg);
}

int main(int argc, char** argv) {
  argc--, argv++; /* Ignore program name. */

  /*
   * Enable debugging with --debug option.
   * Use the other argument as the input file if provided.
   */
   int opened_input = 0;
  for (int i = 0; i < argc; i++)
    if (strcmp(argv[i], "--debug") == 0)
      yydebug = 1;
    else if (!opened_input) {
      opened_input = 1;
      yyin = fopen(argv[i], "r");
    }

  return yyparse();
}

// void standard_error(char* expected, int obtained){
//     printf("Erro: Esperado '%s', obtido '%d'\n", expected, obtained);
// }
