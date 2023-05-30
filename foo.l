%{
#include "foo.tab.h"
#include <string.h>
%}

%%

"+" { return ADD; }
[0-9]+ { yylval.i = atoi(yytext); return NUMBER; }
[a-zA-Z][a-zA-A0-9]* { yylval.s = strdup(yytext); return NAME; }
\n { return EOL; }
. { printf("UNEXPECTED %c\n", *yytext); }

%%
