/** DECLARATIONS AND AUXILIAR FUNCTIONS **/
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"

    #define outputf(format, ...) \
    do { \
        printf(format, ##__VA_ARGS__); \
        fprintf(_outputf, format, ##__VA_ARGS__); \
    } while(0)

    FILE* _outputf = NULL;
    int line_number = 1;

    int keyword(char* s) {
        /* Automaton to check if s is a reserved words. */
        // keywords = ["begin", "const", "do", "else", "end", ]
        if (*s == 'b') {
            if (strcmp(s + 1, "egin") == 0)
                return _BEGIN;
        } else if (*s == 'c') {
            if (strcmp(s + 1, "onst") == 0)
                return CONST;
        } else if (*s == 'd') {
            if (strcmp(s + 1, "o") == 0)
                return DO;
        } else if (*s == 'e') {
            if (*(++s) == 'n') {
                if (strcmp(s + 1, "d") == 0)
                    return END;
            } else if (*s == 'l') {
                if (strcmp(s + 1, "se") == 0)
                    return ELSE;
            }
        } else if (*s == 'f') {
            if (strcmp(s + 1, "or") == 0)
                return FOR;
        } else if (*s == 'i') {
            if (*(++s) == 'f') {
                if (*(s + 1) == '\0') // TODO verify if this is working
                    return IF;
            } else {
                if (strcmp(s, "nteger") == 0)
                    return INTEGER;
            }
        } else if (*s == 'p') {
            if (*(++s) == 'r') {
                if (*(++s) == 'o') {
                    if (*(++s) == 'c') {
                        if (strcmp(s + 1, "edure") == 0)
                            return PROCEDURE;
                    } else if (*s == 'g') {
                        if (strcmp(s + 1, "ram") == 0)
                            return PROGRAM;
                    }
                }
            }
        } else if (*s == 'r') {
            if (*(++s) == 'e') {
                if (*(++s) == 'a') {
                    if (*(++s) == 'd') {
                        if (*(s + 1) == '\0')
                            return READ;
                    } else if (*s == 'l') {
                        if (*(s + 1) == '\0')
                            return REAL;
                    }
                }
            }
        } else if (*s == 't') {
            if (*(s + 1) == 'o')
                return TO;
        } else if (*s == 'v') {
            if (strcmp(s + 1, "ar") == 0)
                return VAR;
        } else if (*s == 'w') {
            if (*(++s) == 'h') {
                if (strcmp(s + 1, "ile") == 0)
                return WHILE;
            } else if (*s == 'r') {
                if (strcmp(s + 1, "ite") == 0)
                return WRITE;
            }
        }

        return IDENT;
    }
%}

/* comment {...} */
start_c "{"
end_c "}"
middle_c [^}]
COMMENT {start_c}{middle_c}*{end_c}

/* basics declarations */
LETTER [a-zA-Z]
DIGIT [0-9]

/* number */
INT {DIGIT}+
REAL {DIGIT}+\.{DIGIT}+
NUMBER {INT}|{REAL}
MALFORMED_NUMBER {NUMBER}{ID}

/* symbols */
RELATION =|<>|>=|<=|>|<
OP_AD \+|-
OP_MUL \*|\/
POINT \.
SYMBOLS ,|:|;|\(|\)|:=
REST {RELATION}|{OP_AD}|{OP_MUL}|{POINT}|{SYMBOLS}

/* identificator */
ID {LETTER}({LETTER}|{DIGIT})*

/* skip */
WHITESPACE " "|\r\n|\n|\t
SKIP {COMMENT}|{WHITESPACE}

/** TRANSLATE RULES **/
%%
"\n"                {line_number++;}
{SKIP}              {/*do nothing*/}
{INT}               {yylval.number=atoi(yytext); return NUMERO_INT;}
{REAL}              {return NUMERO_REAL;}
{MALFORMED_NUMBER}  {outputf("Error: malformed number '%s' in program (line: %d)\n", yytext, line_number);}
{ID}                {printf("%s --> ", yytext); return keyword(yytext);}
{REST}              {return yytext[0];}
.                   {outputf("Error: stray ‘%s’ in program (line: %d)\n", yytext, line_number);}

%%
