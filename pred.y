%{
#include <stdio.h>

int yylex();
int yyerror(char*);


/* show parsing process */
#define YYDEBUG 1
int yydebug = 1;

%}

%token IF THEN NUMBER EOL

/* Define the precedence of IF, THEN, and ELSE */
/*
 * More information on precedence and associativity can be found here:
 * https://www.gnu.org/software/bison/manual/bison.html#Precedence
 */
/* precedence: lowest to highest */
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
    /* Two ways to interpret the following expression:
     * if 1 then (if 2 then 3 else 4)
     * if 1 then (if 2 then 3) else 4
     *
     * When the parser encounters ELSE token, as the ELSE has a higher precedence
     * then the production rule `IF expr THEN expr ELSE expr`, so the parser
     * will shift the ELSE token and reduce the production rule.
     */
    yyparse();
    return 0;
}

int yyerror(char* s) {
  fprintf(stderr, "error: %s\n", s);
}
