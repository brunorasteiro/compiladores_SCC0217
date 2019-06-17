%{/* Prologue */

#include <stdio.h>
#include <string.h>

extern FILE* yyin;
extern int yydebug;
extern int yylex();
extern int yylineno;

void yyerror(const char* s);
const char* prettify_error_message(const char* msg);

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

/* Set bison's error reporting to be verbose. */
%define parse.error verbose

/**
 * Here comes all terminal symbols that have a length
 * greater than 1 as a string (e.g. "begin", ":=", etc).
 * Terminal symbols made of only one character are returned
 * directly by the lexer and are used directly as C
 * character literals in the grammar rules (e.g. ':', '*').
 */
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
        PROGRAM IDENT ';'   corpo '.'   |

        /* Errors on terminal symbols */
        error   IDENT ';'   corpo '.'   |
        PROGRAM error ';'   corpo '.'   |
        PROGRAM IDENT error corpo '.'   |
        PROGRAM IDENT ';'   corpo error |
        error         ';'   corpo '.'
        ;

corpo :
        dc _BEGIN comandos END |

        /* Errors on terminal symbols */
        dc error  comandos END   |
        dc _BEGIN comandos error
        ;

dc : dc_c dc_v dc_p ;

/**
 * Since this rule may not show in code, we can only
 * know it happend when its first terminal appeared.
 */
dc_c :
        CONST IDENT '='   numero ';'  dc_c |
        %empty |

        /* Errors on terminal symbols */
        CONST error '='   numero ';' dc_c |
        CONST IDENT error numero ';' dc_c |
        CONST IDENT '='   error  ';' dc_c
        ;

/**
 * Since this rule may not show in code, we can only
 * know it happend when its first terminal appeared.
 */
dc_v :
        VAR variaveis ':'   tipo_var ';'    dc_v |
        %empty |

        /* Errors on terminal symbols */
        VAR variaveis error tipo_var ';'    dc_v |
        VAR variaveis ':'   tipo_var error  dc_v
        ;

tipo_var :
        REAL | INTEGER |

        /* Errors on terminal symbols */
        error
        ;

variaveis : IDENT mais_var ;

mais_var : ',' variaveis | %empty ;

/* Since this rule may not show in code, we can only know it happend
when the first terminal appeared */
dc_p :
        PROCEDURE   IDENT parametros ';'    corpo_p dc_p |
        %empty |

        /* Errors on terminal symbols */
        PROCEDURE   error parametros ';'    corpo_p dc_p |
        PROCEDURE   IDENT parametros error  corpo_p dc_p
        ;

parametros :
        '('     lista_par ')'   |
        %empty |

        /* Errors on terminal symbols */
        '('     lista_par error
        ;

lista_par : variaveis ':' tipo_var mais_par ;

mais_par : ';' lista_par | %empty ;

corpo_p :
        dc_loc  _BEGIN comandos END ';' |

        /* Errors on terminal symbols */
        dc_loc  error   comandos END    ';' |
        dc_loc  _BEGIN  comandos error  ';'
        ;

dc_loc : dc_v ;

lista_arg :
        '(' argumentos ')' |
        %empty |

        /* Errors on terminal symbols */
        error   argumentos  ')' |
        '('     argumentos  error |

        /* Errors on non terminal symbols */
        '('     error       ')'
        ;

argumentos : IDENT mais_ident ;

mais_ident : ';' argumentos | %empty ;

pfalsa : ELSE cmd | %empty ;

comandos : cmd ';' comandos | %empty ;

cmd_read :
        READ '(' variaveis ')' |

        /* Errors on terminal symbols */
        READ error  variaveis   ')' |
        READ '('    variaveis   error |

        /* Errors on non terminal symbols */
        READ '('    error       ')'
        ;

cmd_write :
        WRITE '(' variaveis ')' |

        /* Errors on terminal symbols */
        WRITE error  variaveis   ')' |
        WRITE '('    variaveis   error |

        /* Errors on non terminal symbols */
        WRITE '('    error       ')'
        ;

cmd_while :
        WHILE '(' condicao ')' DO cmd |

        /* Errors on terminal symbols */
        WHILE error condicao   ')'      DO      cmd |
        WHILE '('   condicao   error    DO      cmd |
        WHILE '('   condicao   ')'      error   cmd |

        /* Errors on non terminal symbols */
        WHILE '('   error       ')'         DO      cmd |
        WHILE '('   condicao    ')'         DO      error
        ;

cmd_if : IF condicao THEN cmd pfalsa ;


cmd_assign :
        IDENT ":=" expressao |

        /* Errors on non terminal symbols */
        IDENT ":=" error
        ;


cmd_fcall : IDENT lista_arg ;

cmd_block_code :
        _BEGIN comandos END |

        /* Errors on non terminal symbols */
        _BEGIN error END
        ;

cmd_for :
        FOR IDENT ":=" expressao TO expressao DO cmd |

        /* Errors on terminal symbols */
        FOR error ":=" expressao TO expressao DO cmd |
        FOR IDENT error expressao TO expressao DO cmd |
        FOR IDENT ":=" expressao error expressao DO cmd |
        FOR IDENT ":=" expressao TO expressao error cmd |

        /* Errors on non terminal symbols */
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

    /* Errors on terminal symbols */
    expressao error expressao |

    /* Errors on non terminal symbols */
    error relacao expressao |
    expressao relacao error
    ;

relacao : '=' | "<>" | ">=" | "<=" | '>' | '<' ;

expressao : termo outros_termos ;

op_un : '+' | '-' | %empty ;

outros_termos :
        op_ad termo outros_termos |
        %empty |

        /* Errors on non terminal symbols */
        op_ad error outros_termos
        ;

op_ad : '+' | '-' ;

termo :
        op_un fator mais_fatores |

        /* Errors on non terminal symbols */
        error fator mais_fatores
        ;

mais_fatores :
        op_mul fator mais_fatores |
        %empty |

        /* Errors on non terminal symbols */
        op_mul error mais_fatores
        ;

op_mul : '*' | '/' ;

fator : IDENT | numero | '(' expressao ')' ;

numero : NUMERO_INT | NUMERO_REAL ;

%% /* Epilogue */

/**
 * This function is invoked by the parser whenver it
 * encouters an error. The error messages returned from
 * the parser are simply prettified and printed to the
 * screen.
 */
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
      yyin = fopen(argv[i], "r");
      if (yyin)
        opened_input = 1;
      else {
        fprintf(stderr, "Error opening file \"%s\" (reading from stdin instead)\n", argv[i]);
        yyin = stdin;
      }
    }

  return yyparse();
}
