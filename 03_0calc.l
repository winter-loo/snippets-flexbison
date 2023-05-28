%{
#include "03_0calc.tab.h"
%}

%%

"+" { return ADD; }
[0-9]+ { yylval = atoi(yytext); return NUMBER; }
\n { return EOL; }
. { printf("UNEXPECTED %c\n", *yytext); }

%%
