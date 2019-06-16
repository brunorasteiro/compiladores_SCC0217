/**
 * This file defines the main function for the
 * lexical analyser alone, as specified in the
 * first assignment.
 */
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"

extern FILE* yyin;
extern char* yytext;
extern int yylex();

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
    case OP_ASSIGN:
      return ":=";
    case OP_DIFF:
      return "<>";
    case OP_GE:
      return ">=";
    case OP_LE:
      return "<=";
    default: {
      char* label = (char*) malloc(2);
      *label = (char) token;
      *(label + 1) = '\0';
      return label;
    }
  }
}
