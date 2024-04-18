%{
#include "pred.tab.h"
%}

%%


"if" { return IF; }

"else" { return ELSE; }

"then" { return THEN; }

" " { /* ignore */ ; }

[0-9]+ { yylval = atoi(yytext); return NUMBER; }

\n { return EOL; }

. { printf("UNEXPECTED %c\n", *yytext); }

%%
