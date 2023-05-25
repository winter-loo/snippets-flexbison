%top{
  /* --------------------------------
   * define python f-string syntax
   * --------------------------------
   */
}

%{
#include <string.h>
%}
%option outfile="fstring.c"

/* define state identifiers */
%x fstr
%x inpo

/* define start and stop conditions of the state */
fstr_start  f\"
fstr_stop   \"
inpo_start  "{"
inpo_stop   "}"

/* use human readable name instead of regex */
identifier [a-zA-Z_][a-zA-Z0-9_][^}]*

%%

{fstr_start} { printf("fstr started\n"); BEGIN(fstr); }
<fstr>{inpo_start} { printf("interpolation will start\n"); BEGIN(inpo); } 
<fstr>[^}{"]?* { printf("whatever, length: %ld\n", strlen(yytext)); }
<inpo>{identifier} { printf("variable name: |%s|\n", yytext); }
<inpo>{inpo_stop} { printf("interpolation will stop\n"); BEGIN(fstr); }
<fstr>{fstr_stop} { printf("fstr stop\n"); BEGIN(INITIAL); }

. { /* ignore non f-strings */ }

%%

int main(int argc, char* argv[]) {
  yylex();
}
