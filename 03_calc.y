%{
#include <stdio.h>
%}

%token NUMBER
%token ADD SUB MUL DIV ABS
%token EOL
%token OP CP
%token COMMENT

%%

calclist: /* nothing */
  | COMMENT EOL { }
  | calclist exp EOL { printf("= %d\n", $2); }
  ;

exp: factor /* default $$ = $1 */
  | exp ADD factor { $$ = $1 + $3; }
  | exp SUB factor { $$ = $1 - $3; }
  ;

factor: term /* default $$ = $1 */
  | factor MUL term { $$ = $1 * $3; }
  | factor DIV term { $$ = $1 / $3; }
  ;

term: NUMBER
  | ABS term { $$ = $2 >= 0 ? $2 : -$2; }
  | OP exp CP { $$ = $2; }
  ;

%%
int main(int argc, char** argv) {
  yyparse();
}

int yyerror(char* s) {
  fprintf(stderr, "error: %s\n", s);
}
