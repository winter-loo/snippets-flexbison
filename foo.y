%{
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>

int yylex();
int yyerror(char*, ...);

/* show parsing process */
#define YYDEBUG 0
int yydebug = 1;
%}

%union {
  int i;
  char* s;
}

%locations
%token <i> NUMBER
%token ADD
%token EOL
%token <s> NAME

%type <s> exp

%%

exp: /* reduce to nothing */ { $$ = ""; }
   | exp NUMBER ADD NUMBER EOL {
        int n = $2 + $4;
        char * s = malloc(n);
        if (s == NULL) {
          yyerror("no enough space");
          exit(1);
        }
        s[n-1]= '\0';
        for (int i = 0; i < n - 1; i++) {
          s[i] = 'a';
        }
        $$ = s;
     }
   | exp NAME EOL { $$ = $2; }
   ;

%%
int main(int argc, char** argv) {
  yyparse();
}

int yyerror(char* s, ...) {
  va_list ap;
  va_start(ap, s);

  if (yylloc.first_line) {
    fprintf(stderr, "%d.%d-%d.%d: error", yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column);  
  }
  vfprintf(stderr, s, ap);
  fprintf(stderr, "\n");
}
