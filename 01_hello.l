%top {
/*----------------------------
 * I WILL BE PLACED AT THE TOP
 * OF GENERATE C SOURCE FILE
 *----------------------------
 */
int g_this_is_my_global_var = 10;

}
/* The first section ignored */

/*------------------------------------
 * The second section goes below '%%'.
 * - It comprises rules.
 * - Each rule has a pattern and action.
 * - Pattern expressed in regular expression.
 * - Action is surrounded by '{' and '}'.
 *   - Inside action, c statement goes.
 *   - If nothing matches, default behavior is echoing back.
 * - Pattern must be followed by '{' at the same line.
 *------------------------------------
 */
%%

hello {
        printf("Hello, there");
      }

%%
/* The third section starts here */
int main() {
  yylex();
  printf("welcome back anytime\n");
  return 0;
}
