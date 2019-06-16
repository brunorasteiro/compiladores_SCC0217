%{
#include<stdio.h>
int yylex();
void yyerror(char* s);
void errfunc(const char* str) {
    printf("Erro sintatico: Era esperado o comando '%s' \n", str);
    return;

}
%}

%union 
{
    int integer;
    double real;
    char *string;
}


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
%token OP_DIF
%token OP_GE
%token OP_LE
%token PROCEDURE
%token PROGRAM
%token READ
%token REAL
%token SYMB_ASSIGN
%token THEN
%token TO
%token VAR
%token WHILE
%token WRITE
%token _BEGIN



%%



programa :
        PROGRAM IDENT ';' corpo '.' {printf("######## <program> sucesso\n");}|

        /* Terminals errors */
        error IDENT ';' corpo '.' { yyerrok; errfunc("program"); }|
        PROGRAM error ';' corpo '.' { yyerrok; errfunc("identificador"); }|
        PROGRAM IDENT error corpo '.' { yyerrok; errfunc(";"); }|
        PROGRAM IDENT ';' corpo error { yyerrok; errfunc("."); }
        ;

corpo : 
        dc _BEGIN comandos END |

        /* Terminals errors */
        dc error comandos END { yyerrok; errfunc("begin"); }|
        dc _BEGIN comandos error  { yyerrok; errfunc("end"); }
        ;

/* Declarations might not even be in the program. 
So it is safer to assume that there would be declarions if there were errors
before other declaration*/
dc : 
        dc_c dc_v dc_p |

        /* Non terminals errors */
        error dc_v dc_p |
        dc_c error dc_p
        ;

/* OBS: left side recursion is actually more efficient in yacc */
/* Since this rule may not show in code, we can only know it happend 
when the first terminal appeared */
dc_c : 
        CONST IDENT '=' numero ';' dc_c | %empty |

        /* Terminals errors */
        CONST error '=' numero ';' dc_c |
        CONST IDENT error numero ';' dc_c |
        CONST IDENT '=' error ';' dc_c |
        CONST IDENT '=' numero error dc_c 
        ;
/* Since this rule may not show in code, we can only know it happend 
when the first terminal appeared */
dc_v : 
        VAR variaveis ':' tipo_var ';' dc_v | %empty |

        /* Terminals errors */
        VAR variaveis error tipo_var ';' dc_v |
        VAR variaveis ':' tipo_var error dc_v 
        ;

tipo_var : 
        REAL | INTEGER |

        /* Terminals errors */
        error
        ;

variaveis : IDENT mais_var ;

mais_var : ',' variaveis | %empty ;

/* Since this rule may not show in code, we can only know it happend 
when the first terminal appeared */
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
   IDENT SYMB_ASSIGN expressao |
   IDENT lista_arg |
   _BEGIN comandos END |
   FOR IDENT SYMB_ASSIGN expressao TO expressao DO cmd ;

condicao : expressao relacao expressao ;

relacao : '=' | OP_DIF | OP_GE | OP_LE | '>' | '<' ;

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

void yyerror(char *s) {
    extern int line_number;
    extern char* yytext;
    fprintf(stderr, "line %d: %s\n", line_number, yytext);
} 


void main()
{
    extern int yy_flex_debug;
    yy_flex_debug = 0; // lexical analyzer switch: 1 - Turn ON; 0 - Turn OFF
	yyparse();



	// // printf("expr válida \n");
	// int token;
    // while ((token = yylex()) != 0) 
    // {
    //     switch (token)
    //     {
    //     case NUMERO_INT:
    //         printf("%d %d\n", yylval.integer, token);
    //         break;
    //     case NUMERO_REAL:
    //         printf("%f %d\n", yylval.real, token);
    //         break;
    //     default:
    //         printf("%s %d\n", yylval.string, token);
    //         break;
    //     }
    // }
    // return;
}

