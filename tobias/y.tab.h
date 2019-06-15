/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    _BEGIN = 258,
    CONST = 259,
    DO = 260,
    ELSE = 261,
    END = 262,
    FOR = 263,
    IDENT = 264,
    IF = 265,
    INTEGER = 266,
    NUMERO_INT = 267,
    NUMERO_REAL = 268,
    PROCEDURE = 269,
    PROGRAM = 270,
    READ = 271,
    REAL = 272,
    THEN = 273,
    TO = 274,
    VAR = 275,
    WHILE = 276,
    WRITE = 277
  };
#endif
/* Tokens.  */
#define _BEGIN 258
#define CONST 259
#define DO 260
#define ELSE 261
#define END 262
#define FOR 263
#define IDENT 264
#define IF 265
#define INTEGER 266
#define NUMERO_INT 267
#define NUMERO_REAL 268
#define PROCEDURE 269
#define PROGRAM 270
#define READ 271
#define REAL 272
#define THEN 273
#define TO 274
#define VAR 275
#define WHILE 276
#define WRITE 277

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 8 "sintaxe.y" /* yacc.c:1909  */

    int number;
    char *string;

#line 103 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
