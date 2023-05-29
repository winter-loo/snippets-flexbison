/* recognize tokens for the calculator */

%{
#include "08_calc.h"
#include "08_calc.tab.h"

struct symbol symtab[NHASH];

%}
%option noyywrap nodefault yylineno case-insensitive

EXP ([Ee]?[+-]?[0-9]+)

%%

"+" |
"-" |
"*" |
"/" |
"=" |
"|" |
"," |
";" |
"(" |
")"     { return yytext[0]; }

">" { yylval.fn = 1; return CMP; }
"<" { yylval.fn = 2; return CMP; }
"<>" { yylval.fn = 3; return CMP; }
"==" { yylval.fn = 4; return CMP; }
">=" { yylval.fn = 5; return CMP; }
"<=" { yylval.fn = 6; return CMP; }

"if" { return IF; }
"then" { return THEN; }
"else" { return ELSE; }
"while" { return WHILE; }
"do" { return DO; }
"fn" { return FN; }

"sqrt" { yylval.fn = B_sqrt; return FUNC; }
"exp" { yylval.fn = B_exp; return FUNC; }
"log" { yylval.fn = B_log; return FUNC; }
"print" { yylval.fn = B_print; return FUNC; }

[a-zA-Z][a-zA-Z0-9]* { yylval.s = lookup(yytext); return NAME; }

[0-9]+"."[0-9]*{EXP}? |
"."?[0-9]+{EXP}? {
  /* yylval is defined as union in 07_calc.y */
  yylval.d = atof(yytext); return NUMBER; }

\n  { return EOL; }
"//".*
[ \t]

\\\n { printf("c> "); } /* ignore line continuation */

. { yyerror("unexpected input: |%s|\n", yytext); }
