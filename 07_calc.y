%{
#include <stdio.h>
#include <stdlib.h>
#include "07_calc.h"
int yylex();
%}

/* declre types for all symbols */
%union {
  struct ast *a;
  double d;
}

/* declare terminal symbol `NUMBER` has the value of `d` */
%token <d> NUMBER
%token EOL

/* declare other nonterminal symbols has the value of `a` */
%type <a> exp factor term

%%

calclist: /* nothing */
  | calclist exp EOL {
      /* evaluate and print the AST */
      printf("= %4.4g\n", eval($2));
      /* free up the AST */
      treefree($2);
      printf("> ");
    }
  | calclist EOL { printf("> "); } /* blank line o a comment */
  ;

exp: factor /* default $$ = $1 */
  | exp '+' factor { $$ = newast('+', $1, $3); }
  | exp '-' factor { $$ = newast('-', $1, $3); }
  ;

factor: term /* default $$ = $1 */
  | factor '*' term { $$ = newast('*', $1, $3); }
  | factor '/' term { $$ = newast('/', $1, $3); }
  ;

term: NUMBER { $$ = newnum($1); }
  | '|' term { $$ = newast('|', $2, NULL); }
  | '(' exp ')' { $$ = $2; }
  | '-' term { $$ = newast('M', $2, NULL); }
  ;

%%
