%{/* Prologue */

#include <stdio.h>
#include <string.h>
extern FILE* yyin;
extern int yydebug;
extern int yylex();
extern int yylineno;
void yyerror(const char* s);

%} /* Bison Declarations */

/* Especify the grammar's initial non-terminal symbol: "programa". */
%start programa

/**
 * The following bison statement supresses the one
 * conflict warning. The conflict comes from the
 * ambiguity of the rules that generate if-then-else
 * constructs.
 */
%expect 1

%define parse.error verbose

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

programa :
        PROGRAM IDENT ';'   corpo '.' |

        /* Terminals errors */
        error   IDENT ';'   corpo '.'   |
        PROGRAM error ';'   corpo '.'   |
        PROGRAM IDENT error corpo '.'   |
        PROGRAM IDENT ';'   corpo error |

        // error ';' {extern int line_number; pv_number = line_number;} corpo '.' { yyerrok; errfunc("CU DE CURIOSO"); printf("\nLINHA %d\n", pv_number); }
        error ';' corpo '.'
        ;

corpo :
        dc _BEGIN   comandos END |

        /* Terminals errors */
        dc error    comandos END   |
        dc _BEGIN   comandos error
        ;

dc : dc_c dc_v dc_p ;

/* Since this rule may not show in code, we can only know it happend
when the first terminal appeared */
dc_c :
        CONST IDENT '='     numero ';'      dc_c | %empty |

        /* Terminals errors */
        CONST error '='     numero  ';'     dc_c |
        CONST IDENT error   numero  ';'     dc_c |
        CONST IDENT '='     error   ';'     dc_c
        ;

/* Since this rule may not show in code, we can only know it happend
when the first terminal appeared */
dc_v :
        VAR     variaveis ':'   tipo_var ';'    dc_v | %empty |

        /* Terminals errors */
        VAR     variaveis error tipo_var ';'    dc_v |
        VAR     variaveis ':'   tipo_var error  dc_v
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
dc_p :
        PROCEDURE   IDENT parametros ';'    corpo_p dc_p | %empty |

        /* Terminals errors */
        PROCEDURE   error parametros ';'    corpo_p dc_p |
        PROCEDURE   IDENT parametros error  corpo_p dc_p
        ;

parametros :
        '('     lista_par ')'   | %empty |

        /* Terminals errors */
        '('     lista_par error
        ;

lista_par : variaveis ':' tipo_var mais_par ;

mais_par : ';' lista_par | %empty ;

corpo_p :
        dc_loc  _BEGIN comandos END ';' |

        /* Terminals errors */
        dc_loc  error   comandos END    ';' |
        dc_loc  _BEGIN  comandos error  ';'
        ;

dc_loc : dc_v ;

lista_arg :
        '(' argumentos ')' | %empty |

        /* Terminals errors */
        error   argumentos  ')' |
        '('     argumentos  error |

        /* Non terminal errors */
        '('     error       ')'
        ;

argumentos : IDENT mais_ident ;

mais_ident : ';' argumentos | %empty ;

pfalsa : ELSE cmd | %empty ;

comandos : cmd ';' comandos | %empty ;

cmd_read :
        READ '(' variaveis ')' |

        /* Terminals errors */
        READ error  variaveis   ')' |
        READ '('    variaveis   error |

        /* Non terminal errors */
        READ '('    error       ')'
        ;

cmd_write :
        WRITE '(' variaveis ')' |

        /* Terminals errors */
        WRITE error  variaveis   ')' |
        WRITE '('    variaveis   error |

        /* Non terminal errors */
        WRITE '('    error       ')'
        ;

cmd_while :
        WHILE '(' condicao ')' DO cmd |

        /* Terminals errors */
        WHILE error condicao   ')'      DO      cmd |
        WHILE '('   condicao   error    DO      cmd |
        WHILE '('   condicao   ')'      error   cmd |

        /* Non terminal errors */
        WHILE '('   error       ')'         DO      cmd |
        WHILE '('   condicao    ')'         DO      error
        ;

cmd_if : IF condicao THEN cmd pfalsa ;


cmd_assign :
        IDENT ":=" expressao |

        /* Non terminal errors */
        IDENT ":=" error
        ;


cmd_fcall :
        IDENT lista_arg

        /* Non terminal errors */
        //| IDENT error
        ;

cmd_block_code :
        _BEGIN comandos END |

        /* Non terminal errors */
        _BEGIN error END
        ;

cmd_for :
        FOR IDENT ":=" expressao TO expressao DO cmd |

        /* Terminal errors */
        FOR error ":=" expressao TO expressao DO cmd |
        FOR IDENT error expressao TO expressao DO cmd |
        FOR IDENT ":=" expressao error expressao DO cmd |
        FOR IDENT ":=" expressao TO expressao error cmd |

        /* Non terminal errors */
        FOR IDENT ":=" error TO expressao DO cmd |
        FOR IDENT ":=" expressao TO error DO cmd |
        FOR IDENT ":=" expressao TO expressao DO error
        ;

cmd :
        cmd_read |
        cmd_write |
        cmd_while |
        cmd_if |
        cmd_assign |
        cmd_fcall |
        cmd_block_code |
        cmd_for
        ;

condicao :
    expressao relacao expressao |

    /* Terminal errors */
    expressao error expressao |

    /* Non terminal errors */
    error relacao expressao |
    expressao relacao error
    ;

relacao : '=' | "<>" | ">=" | "<=" | '>' | '<' ;

expressao : termo outros_termos ;

op_un : '+' | '-' | %empty ;

outros_termos :
        op_ad termo outros_termos | %empty |

        /* Non terminal errors */
        op_ad error outros_termos
        ;

op_ad : '+' | '-' ;

termo :
        op_un fator mais_fatores |

        /* Non terminal errors */
        error fator mais_fatores
        ;

mais_fatores :
        op_mul fator mais_fatores | %empty |

        /* Non terminal errors */
        op_mul error mais_fatores
        ;

op_mul : '*' | '/' ;

fator : IDENT | numero | '(' expressao ')' ;

numero : NUMERO_INT | NUMERO_REAL ;

%% /* Epilogue */

void yyerror(const char* msg) {
  fprintf(stderr, "%s (line: %d)\n", msg, yylineno);
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
