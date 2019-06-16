/* Definitions Section */
%{
#include <stdio.h>
#include "y.tab.h"

int line_number = 1;
%}

%option noyywrap bison-bridge

/* whitespace: / |\t|\r?\n/ */
NEWLINE     \r?\n
WHITESPACE  " "|\t|{NEWLINE}

/* comment: /{[^}]*}/ */
COMMENT \{[^}]*\}

/* alphanum */
LETTER  [a-zA-Z]
DIGIT   [0-9]

/* number */
INT               {DIGIT}+
FLOAT             {DIGIT}+\.{DIGIT}+
NUMBER            {INT}|{FLOAT}
MALFORMED_NUMBER  {NUMBER}{ID}

/* identifier */
ID  {LETTER}({LETTER}|{DIGIT})*

/* Translate Rules */
%%
{NEWLINE}           { line_number++; }
{WHITESPACE}        { /* ignore */ }
{COMMENT}           { /* ignore */ }
{INT}               { return NUMERO_INT; }
{FLOAT}             { return NUMERO_REAL; }
{MALFORMED_NUMBER}  { printf("Error: malformed number '%s' in program (line: %d)\n", yytext, line_number); }
begin               { return _BEGIN; }
const               { return CONST; }
do                  { return DO; }
else                { return ELSE; }
end                 { return END; }
for                 { return FOR; }
if                  { return IF; }
integer             { return INTEGER; }
procedure           { return PROCEDURE; }
program             { return PROGRAM; }
read                { return READ; }
real                { return REAL; }
then                { return THEN; }
to                  { return TO; }
var                 { return VAR; }
while               { return WHILE; }
write               { return WRITE; }
{ID}                { return IDENT; }
":="                { return OP_ATRIBUICAO; }
"<>"                { return OP_DIFERENTE; }
">="                { return OP_MAIOR_IGUAL; }
"<="                { return OP_MENOR_IGUAL; }
"="                 { return OP_IGUAL; }
">"                 { return OP_MAIOR; }
"<"                 { return OP_MENOR; }
"\+"                { return OP_ADICAO; }
"-"                 { return OP_SUBTRACAO; }
"\*"                { return OP_MULTIPLICACAO; }
"\/"                { return OP_DIVISAO; }
"\."                { return PONTO; }
","                 { return VIRGULA; }
":"                 { return DOIS_PONTOS; }
";"                 { return PONTO_VIRGULA; }
"\("                { return ABRE_PARENTESES; }
"\)"                { return FECHA_PARENTESES; }
.                   { printf("Error: stray ‘%s’ in program (line: %d)\n", yytext, line_number); }
