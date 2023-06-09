%{
#include "03_calc.tab.h"
%}

%%

"(" { return OP; }
")" { return CP; }
"//".* { return COMMENT; }
"+" { return ADD; }
"-" { return SUB; }
"*" { return MUL; }
"/" { return DIV; }
"|" { return ABS; }
[0-9]+ { yylval = atoi(yytext); return NUMBER; }
\n { return EOL; }
[ \t] { /* ignore whitespace */ }
. { printf("UNEXPECTED %c\n", *yytext); }

%%
