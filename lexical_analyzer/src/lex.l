/** DECLARAÇÕES **/

/* comentário {...}*/
START_C "{"
END_C "}"
MIDDLE_C [^}]
comment {START_C}{MIDDLE_C}*{END_C}
/* basics declarations */
letter [a-zA-Z]
digit [0-9]
/* numeros */
int {digit}+
real {digit}+\.{digit}+
/* identificador */
id {letter}({letter}|{digit})*


/** REGRAS DE TRADUÇÃO DE REGEX's**/
%%
{comment}
{int}       {printf("numero_int: %s", yytext);}
{real}      {printf("numero_real: %s", yytext);}
{id}        {printf("id: %s", yytext);}
%%

/** FUNÇÕES AUXILIARES **/
int main(){
    yylex();
    return 0;
}