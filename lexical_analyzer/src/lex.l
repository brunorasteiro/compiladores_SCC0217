/** DECLARAÇÕES **/

/* comment {...} */
start_c "{"
end_c "}"
middle_c [^}]
COMMENT {start_c}{middle_c}*{end_c}
/* basics declarations */
LETTER [a-zA-Z]
DIGIT [0-9]
/* numeros */
INT {DIGIT}+
REAL {DIGIT}+\.{DIGIT}+
/* identificador */
ID {LETTER}({LETTER}|{DIGIT})*


/** REGRAS DE TRADUÇÃO DE REGEX's**/
%%
{COMMENT}   {/*do nothing*/}
{INT}       {printf("numero_int: %s", yytext);}
{REAL}      {printf("numero_real: %s", yytext);}
{ID}        {printf("id: %s", yytext);}
%%

/** FUNÇÕES AUXILIARES **/
int main(){
    yylex();
    return 0;
}