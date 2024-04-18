%{
#include <stdio.h>

int yylex();
int yyerror(char*);


/* show parsing process */
#define YYDEBUG 1
int yydebug = 0;

%}

%token IF THEN ELSE NUMBER EOL

/* Define the precedence of IF, THEN, and ELSE */
/*
 * - The IF token has a higher precedence (IFX) than THEN and ELSE.
 *   This means that the IF statement and its associated expressions
 *   will be treated as a single unit.
 *
 * - The THEN token is left-associative, and so is the ELSE token.
 *   This ensures that THEN and ELSE bindings are resolved correctly
 *   in nested IF statements.

 * More information on precedence and associativity can be found here:
 * https://www.gnu.org/software/bison/manual/bison.html#Precedence
 */
%nonassoc IFX
%left THEN
%left ELSE

%%

line_expr: expr EOL ;

expr : 
     IF expr THEN expr ELSE expr %prec IFX
     | IF expr THEN expr
     | NUMBER
     ;

%%

int main()
{
    /* if 1 then if 2 then if 3 then 4 else 5 else 6 else 7 */
    yyparse();
    return 0;
}

int yyerror(char* s) {
  fprintf(stderr, "error: %s\n", s);
}
