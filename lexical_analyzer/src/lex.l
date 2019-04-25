/** DECLARATIONS AND AUXILIAR FUNCTIONS **/
%{
    void id(char* chain){
        /* if chain not in reserved_words */
            printf("%s - id\n", chain);
        /* else
            printf("%s - %s\n", chain, chain);
        */
    }
%}


/* comment {...} */
start_c "{"
end_c "}"
middle_c [^}]
COMMENT {start_c}{middle_c}*{end_c}

/* skip */
SKIP {COMMENT}|\n|" "

/* basics declarations */
LETTER [a-zA-Z]
DIGIT [0-9]

/* number */
INT -?{DIGIT}+
REAL -?{DIGIT}+\.{DIGIT}+
NUMBER {INT}|{REAL}

/* symbols */
RELATION =|<>|>=|<=|>|<
OP_AD \+|-
OP_MUL \*|\/
SYMBOLS ,|:|;|\.|\(|\)

/* identificator */
ID {LETTER}({LETTER}|{DIGIT})*

/** TRANSLATE RULES **/
%%
{SKIP}          {/*do nothing*/}
{NUMBER}        {printf("%s - num\n", yytext);}
{ID}            {id(yytext);}
{RELATION}      {printf("%s - rel\n", yytext);}
{OP_AD}         {printf("%s - op_ad\n", yytext);}
{OP_MUL}        {printf("%s - op_mul\n", yytext);}
{SYMBOLS}       {printf("%s - %s\n", yytext, yytext);}

.               {printf("%s - erro\n", yytext);}

%%

/** AUXILIAR FUNCTIONS **/
int main(){
    yylex();
    return 0;
}

