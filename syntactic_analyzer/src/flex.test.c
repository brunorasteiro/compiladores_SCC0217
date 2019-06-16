#include <stdio.h>
#include "y.tab.h"

extern FILE* yyin;
extern char* yytext;
int yylex();

char* token_label(int token);

int main(int argc, char** argv) {
  argv++, argc--; /* Ignore program name. */
  if (argc > 0)
    yyin = fopen(argv[0], "r");

  int token;
  while (token = yylex())
    printf("%s\t\t- %s\n", yytext, token_label(token));

  return 0;
}

char* token_label(int token) {
  switch (token) {
    case _BEGIN:
      return "begin";
    case CONST:
      return "const";
    case DO:
      return "do";
    case ELSE:
      return "else";
    case END:
      return "end";
    case FOR:
      return "for";
    case IDENT:
      return "ident";
    case IF:
      return "if";
    case INTEGER:
      return "integer";
    case NUMERO_INT:
      return "numero_int";
    case NUMERO_REAL:
      return "numero_real";
    case PROCEDURE:
      return "procedure";
    case PROGRAM:
      return "program";
    case READ:
      return "read";
    case REAL:
      return "real";
    case THEN:
      return "then";
    case TO:
      return "to";
    case VAR:
      return "var";
    case WHILE:
      return "while";
    case WRITE:
      return "write";
    case OP_IGUAL:
      return "=";
    case OP_DIFERENTE:
      return "<>";
    case OP_MAIOR_IGUAL:
      return ">=";
    case OP_MENOR_IGUAL:
      return "<=";
    case OP_MAIOR:
      return ">";
    case OP_MENOR:
      return "<";
    case OP_ADICAO:
      return "+";
    case OP_SUBTRACAO:
      return "-";
    case OP_MULTIPLICACAO:
      return "*";
    case OP_DIVISAO:
      return "/";
    case OP_ATRIBUICAO:
      return ":=";
    case PONTO:
      return ".";
    case VIRGULA:
      return ",";
    case DOIS_PONTOS:
      return ":";
    case PONTO_VIRGULA:
      return ";";
    case ABRE_PARENTESES:
      return "(";
    case FECHA_PARENTESES:
      return ")";
  }
}
