%{
#include "07_calc.h"
#include "07_calc.tab.h"
%}

EXP ([Ee]?[+-]?[0-9]+)

%%

"+" |
"-" |
"*" |
"/" |
"|" |
"(" |
")" { return yytext[0]; }

[0-9]+"."[0-9]*{EXP}? |
"."?[0-9]+{EXP}? {
  /* yylval is defined as union in 07_calc.y */
  yylval.d = atof(yytext); return NUMBER; }

\n  { return EOL; }
"//".*
[ \t]
[a-z]+ { yyerror("unexpected input: |%s|\n", yytext); }

%%
