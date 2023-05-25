%top {
/*----------------------------
 * I WILL BE PLACED AT THE TOP
 * OF GENERATE C SOURCE FILE
 *----------------------------
 */
int g_this_is_my_global_var = 10;

}
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
