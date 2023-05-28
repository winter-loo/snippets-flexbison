%{
#include <stdio.h>

int yylex();
int yyerror(char*);

/* show parsing process */
#define YYDEBUG 1
int yydebug = 1;
%}

%token NUMBER
%token ADD
%token EOL

%%

calclist: exp EOL { /* match the first expression */
            /* after the first match, the internal stack
             * has the nonterminal `calclist` value in its top,
             * therefore, the next match must begin with `calclist`.
             * Otherwise, the parser complains with 'syntax error'.
             */
            printf("base)= %d\n", $1);
          }
        | calclist exp EOL { /* match other exressions */
            printf("recr)= %d\n", $2);
          }
        ;

exp: NUMBER ADD NUMBER { $$ = $1 + $3; }

%%
int main(int argc, char** argv) {
  yyparse();
}

int yyerror(char* s) {
  fprintf(stderr, "error: %s\n", s);
}
