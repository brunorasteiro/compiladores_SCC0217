/** DECLARATIONS AND AUXILIAR FUNCTIONS **/
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"

    #define DEBUG 0

    #define outputf(format, ...) \
    do { \
        printf(format, ##__VA_ARGS__); \
        fprintf(_outputf, format, ##__VA_ARGS__); \
    } while(0)
    
    int line_number = 1;
    FILE* _outputf = NULL;
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
RELATION =|>|<
OP_AD \+|-
OP_MUL \*|\/
SYMBOLS \.|,|:|;|\(|\)
REST {RELATION}|{OP_AD}|{OP_MUL}|{SYMBOLS}

/* identificator */
ID {LETTER}({LETTER}|{DIGIT})*

/* skip */
WHITESPACE " "|\r\n|\n|\t
SKIP {COMMENT}|{WHITESPACE}

/** TRANSLATE RULES **/
%%
"\n"                     {line_number++;}
{SKIP}                   {/*do nothing*/}

{INT}                    {if (DEBUG) printf("%s\n", yytext); yylval.integer = atoi(yytext); return NUMERO_INT;}
{REAL}                   {if (DEBUG) printf("%s\n", yytext); yylval.real = atof(yytext); return NUMERO_REAL;}
{MALFORMED_NUMBER}       {if (DEBUG) printf("%s\n", yytext); outputf("Error: malformed number '%s' in program (line: %d)\n", yytext, line_number);}

"begin"                  {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return _BEGIN;}
"const"                  {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return CONST;}
"do"                     {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return DO;}
"else"                   {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return ELSE;}
"end"                    {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return END;}
"for"                    {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return FOR;}
"if"                     {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return IF;}
"integer"                {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return INTEGER;}
"procedure"              {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return PROCEDURE;}
"program"                {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return PROGRAM;}
"read"                   {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return READ;}
"real"                   {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return REAL;}
"then"                   {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return THEN;}
"to"                     {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return TO;}
"var"                    {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return VAR;}
"while"                  {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return WHILE;}
"write"                  {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return WRITE;}
{ID}                     {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return IDENT;}

"<>"                     {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return OP_DIF;}
"<="                     {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return OP_LE;}
">="                     {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return OP_GE;}
":="                     {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return SYMB_ASSIGN;}
{REST}                   {if (DEBUG) printf("%s\n", yytext); yylval.string = strdup(yytext); return yytext[0];}

.                        {outputf("Error: stray ‘%s’ in program (line: %d)\n", yytext, line_number);}

%%
