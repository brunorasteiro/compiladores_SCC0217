/** DECLARATIONS AND AUXILIAR FUNCTIONS **/
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

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
            return strcmp(s + 1, "egin") == 0;
        } else if (*s == 'c') {
            return strcmp(s + 1, "onst") == 0;
        } else if (*s == 'd') {
            return strcmp(s + 1, "o") == 0;
        } else if (*s == 'e') {
            if (*(++s) == 'n') {
                return strcmp(s + 1, "d") == 0;
            } else if (*s == 'l') {
                return strcmp(s + 1, "se") == 0;
            }
        } else if (*s == 'f') {
            return strcmp(s + 1, "or") == 0;
        } else if (*s == 'i') {
            if (*(++s) == 'f') {
                return *(s + 1) == '\0';
            } else {
                return strcmp(s, "nteger") == 0;
            }
        } else if (*s == 'p') {
            if (*(++s) == 'r') {
                if (*(++s) == 'o') {
                    if (*(++s) == 'c') {
                        return strcmp(s + 1, "edure") == 0;
                    } else if (*s == 'g') {
                        return strcmp(s + 1, "ram") == 0;
                    }
                }
            }
        } else if (*s == 'r') {
            if (*(++s) == 'e') {
                if (*(++s) == 'a') {
                    if (*(++s) == 'd') {
                        return *(s + 1) == '\0';
                    } else if (*s == 'l') {
                        return *(s + 1) == '\0';
                    }
                }
            }
        } else if (*s == 't') {
            if (*(++s) == 'o') {
                return *(++s) == '\0';
            } else if (*s == 'h') {
                return strcmp(s + 1, "en") == 0;
            }
        } else if (*s == 'v') {
            return strcmp(s + 1, "ar") == 0;
        } else if (*s == 'w') {
            if (*(++s) == 'h') {
                return strcmp(s + 1, "ile") == 0;
            } else if (*s == 'r') {
                return strcmp(s + 1, "ite") == 0;
            }
        }

        return 0;
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

/* identificator */
ID {LETTER}({LETTER}|{DIGIT})*

/* skip */
WHITESPACE " "|\r\n|\n|\t
SKIP {COMMENT}|{WHITESPACE}

/** TRANSLATE RULES **/
%%
"\n"                {line_number++;}
{SKIP}              {/*do nothing*/}
{INT}               {outputf("%s - number_int\n", yytext);}
{REAL}              {outputf("%s - number_real\n", yytext);}
{MALFORMED_NUMBER}  {outputf("Error: malformed number '%s' in program (line: %d)\n", yytext, line_number);}
{ID}                {outputf("%s - %s\n", yytext, keyword(yytext) ? yytext : "id");}
{RELATION}          {outputf("%s - %s\n", yytext, yytext);}
{OP_AD}             {outputf("%s - %s\n", yytext, yytext);}
{OP_MUL}            {outputf("%s - %s\n", yytext, yytext);}
{POINT}             {outputf("%s - %s\n", yytext, yytext);}
{SYMBOLS}           {outputf("%s - %s\n", yytext, yytext);}
.                   {outputf("Error: stray ‘%s’ in program (line: %d)\n", yytext, line_number);}

%%

/** AUXILIAR FUNCTIONS **/
int main() {
    _outputf = fopen("output.txt", "w");
    if(_outputf == NULL) {
      printf("Error: could not open output file\n");
      exit(1);
    }

    yylex();

    fclose(_outputf);

    return 0;
}
