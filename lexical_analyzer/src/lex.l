/** DECLARATIONS AND AUXILIAR FUNCTIONS **/
%{
    #include <string.h>

    void id(char* chain){
        /* if chain in table of reserved words */
        if (
            (strcmp(chain, "program") == 0) ||
            (strcmp(chain, "var") == 0) ||
            (strcmp(chain, "integer") == 0) ||
            (strcmp(chain, "begin") == 0) ||
            (strcmp(chain, "end") == 0)
           )
            printf("%s - %s\n", chain, chain);

        else
            printf("%s - id\n", chain);
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

/* boundary */
WS " "|\r\n|\n|\t
BOUNDARY {WS}|{RELATION}|{OP_AD}|{OP_MUL}|{SYMBOLS}

/* skip */
SKIP {COMMENT}|{WS}

/** TRANSLATE RULES **/
%%
{SKIP}              {/*do nothing*/}
{INT}               {printf("%s - num_int\n", yytext);}
{REAL}              {printf("%s - num_real\n", yytext);}
{MALFORMED_NUMBER}  {printf("%s - malformed_num\n", yytext);}
{ID}                {id(yytext);}
{RELATION}          {printf("%s - rel\n", yytext);}
{OP_AD}             {printf("%s - op_ad\n", yytext);}
{OP_MUL}            {printf("%s - op_mul\n", yytext);}
{POINT}             {printf("%s - %s\n", yytext, yytext);}
{SYMBOLS}           {printf("%s - %s\n", yytext, yytext);}

.                   {printf("error: stray ‘%s’ in program\n", yytext);}

%%

/** AUXILIAR FUNCTIONS **/
int main(){
    yylex();
    return 0;
}

