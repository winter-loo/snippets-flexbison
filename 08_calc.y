%{
#include <stdio.h>
#include <stdlib.h>
#include "08_calc.h"

int yylex();
#define YYDEBUG 0
int yydebug = 1;
%}

%locations

%union {
  struct ast *a;
  double d;
  struct symbol *s;   /* which symbol */
  struct symlist *sl;
  int fn;             /* which function */
}

/* declare tokens */
%token <d> NUMBER
%token <s> NAME
%token <fn> FUNC
%token EOL
%token IF THEN ELSE WHILE DO FN

/* declaration of precedence
 * - the first line operator has lowest precedence
 * - the last line operator has highest precedence
 * - '=' is right associative
 * - '+', '-', '*', '/' is left associative
 */
%nonassoc <fn> CMP
%right '='
%left '+' '-'
%left '*' '/'
%nonassoc '|' UMINUS

/* nontermial symbols */
%type <a> exp stmt list explist
%type <sl> symlist

/* tells bison which rule is the top-level rule,
   so we don't have to put it at the beginning of
   the parser. */
%start calclist

%%

stmt: IF exp THEN list            { $$ = newflow('I', $2, $4, NULL); }
    | IF exp THEN list ELSE list  { $$ = newflow('I', $2, $4, $6); }
    | WHILE exp DO list           { $$ = newflow('W', $2 ,$4, NULL); }
    | exp
    ;

list: /* nothing */ { $$ = NULL; }
    | stmt ';' list { if ($3 == NULL)
                        $$ = $1;
                      else
                        $$ = newast('L', $1, $3);
                    }


exp: exp CMP exp          { $$ = newcmp($2, $1, $3); }
  | exp '+' exp           { $$ = newast('+', $1,$3); }
  | exp '-' exp           { $$ = newast('-', $1,$3);}
  | exp '*' exp           { $$ = newast('*', $1,$3); }
  | exp '/' exp           { $$ = newast('/', $1,$3); }
  | '|' exp               { $$ = newast('|', $2, NULL); }
  | '(' exp ')'           { $$ = $2; }
  | '-' exp %prec UMINUS  { $$ = newast('M', $2, NULL); }
  | NUMBER                { $$ = newnum($1); }
  | NAME                  { $$ = newref($1); }
  | NAME '=' exp          { $$ = newasgn($1, $3); }
  | FUNC '(' explist ')'  { $$ = newfunc($1, $3); }
  | NAME '(' explist ')'  { $$ = newcall($1, $3); }
;

explist: exp
       | exp ',' explist { $$ = newast('L', $1, $3); }
;
symlist: NAME         { $$ = newsymlist($1, NULL); }
  | NAME ',' symlist  { $$ = newsymlist($1, $3); }
;

calclist: /* nothing */
  | calclist stmt EOL {
      printf("= %4.4g\n> ", eval($2));
      treefree($2);
    }
  | calclist FN NAME '(' symlist ')' '=' stmt EOL {
      dodef($3, $5, $8);
      printf("Defined %s\n> ", $3->name);
    }
  | calclist error EOL { /* 'error' is a special token to indicate none of above rules match */
      yyerrok;  /* reset bison error state to continue parsing */
      printf("> ");
    }
;

%%

