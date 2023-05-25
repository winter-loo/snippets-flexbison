/* The first section ignored */

/* The second section starts here */
%%
hello { printf("Hello, there"); }
.* { printf("YOU SAY: %s", yytext); }

%%
/* The third section starts here */
int main() {
  yylex();
  printf("welcome back anytime\n");
  return 0;
}
