/* Definitions Section */
%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}

%option yylineno
%option noyywrap
%option bison-bridge

/* whitespace: / |\t|\r?\n/ */
WHITESPACE  " "|\t|\r?\n

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
{WHITESPACE}        { /* ignore */ }
{COMMENT}           { /* ignore */ }
{INT}               { return NUMERO_INT; }
{FLOAT}             { return NUMERO_REAL; }
{MALFORMED_NUMBER}  { printf("Error: malformed number '%s' in program (line: %d)\n", yytext, yylineno); }
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
":="                { return OP_ASSIGN; }
"<>"                { return OP_DIFF; }
">="                { return OP_GE; }
"<="                { return OP_LE; }
"="                 { return '='; }
">"                 { return '>'; }
"<"                 { return '<'; }
"\+"                { return '+'; }
"-"                 { return '-'; }
"\*"                { return '*'; }
"\/"                { return '/'; }
"\."                { return '.'; }
","                 { return ','; }
":"                 { return ':'; }
";"                 { return ';'; }
"\("                { return '('; }
"\)"                { return ')'; }
.                   { printf("Error: stray ‘%s’ in program (line: %d)\n", yytext, yylineno); }
