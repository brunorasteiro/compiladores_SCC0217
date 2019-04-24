/** DECLARAÇÕES **/

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
SIMBOLO [;]

/* numbers */
INT -?{DIGIT}+
REAL -?{DIGIT}+\.{DIGIT}+
NUMBER {INT}|{REAL}

/* symbols */
RELATION =|<>|>=|<=|>|<
OP_AD [\+-]
OP_MUL [\*/]

/* identificators */
ID {LETTER}({LETTER}|{DIGIT})*


/** REGRAS DE TRADUÇÃO DE REGEX's**/
%%
{SKIP}      {/*do nothing*/}
{NUMBER}    {printf("num: %s\n", yytext);}
{ID}        {printf("id: %s\n", yytext);}
{RELATION}  {printf("rel: %s\n", yytext);}
%%

/** FUNÇÕES AUXILIARES **/
int main(){
    yylex();
    return 0;
}