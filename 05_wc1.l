%{
#include <stdio.h>
#include <string.h>

int chars = 0;
int words = 0;
int lines = 0;
%}

%%

[a-zA-Z0-9]+ { words++; chars += strlen(yytext); }
\n { chars++; lines++; }
. { chars++; }

%%

int main(int argc, char* argv[]) {
  int i;
  int totlines = 0;
  int totwords = 0;
  int totchars = 0;

  /* read from stdin */
  if (argc < 2) {
    yylex();
    printf("%-8d%-8d%-8d\n", lines, words, chars);
    return 0;
  }

  /* read from multiple files */
  for (i = 1; i < argc; i++) {
    FILE* f;
    if (!(f = fopen(argv[i], "r"))) {
      perror(argv[i]);
      return 1;
    }

    yyrestart(f);
    yylex();
    fclose(f);
    if (argc > 1) {
      printf("%-8d%-8d%-8d %s\n", lines, words, chars, argv[i]);
    } else {
      printf("%-8d%-8d%-8d\n", lines, words, chars);
    }
    totlines += lines; lines = 0;
    totwords += words; words = 0;
    totchars += chars; chars = 0;
  }

  if (argc > 1) {
    printf("%-8d%-8d%-8d %s\n", totlines, totwords, totchars, "total");
  }
  return 0;
}
