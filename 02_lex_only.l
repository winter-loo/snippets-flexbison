%{
  enum yytokentype {
    NUMBER = 258,
    ADD,
    SUB,
    MUL,
    DIV,
    ABS,
    EOL
  };

  int yylval;
%}

%%

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

int main(int argc, char **argv) {
  int tok;

  /* yylex waits value returned from rule action */
  while (tok = yylex()) {
    printf("%d", tok);
    if (tok == NUMBER) printf(" = %d\n", yylval);
    else printf("\n");
  }
}
