%{
#include "y.tab.h"
#include<math.h>
extern yyval;
%}
%%
[a] return A;
[b] return B;
[.|\n] {return yytext[0];}
%%