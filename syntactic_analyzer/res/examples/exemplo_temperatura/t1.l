%{
#include <stdio.h>
#include "y.tab.h"
%}

%%
[0-9]+				return NUMERO;
calor				return CALOR;
ligado|desligado	return ESTADO;
temperatura			return TEMPERATURA;
\n 					/* ignorar o fim da linha*/;
[ \t]+ 				/*ignorar espaço em branco*/;

%%