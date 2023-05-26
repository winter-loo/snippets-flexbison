%{
struct bufstack {
  struct bufstack *prev; /* previous entry */
  YY_BUFFER_STATE bs; /* saved buffer */
  int lineno; /* saved line number */
  char *filename; /* name of this file */
  FILE *f; /* current file */
} *curbs = 0;

char *curfilename; /* name of current input file */

int newfile(char *fn);
int popfile(void);
%}

/* yywrap() function controls scanner to continue
 * scanning other input file or terminate now when
 * scanner reaches the end of current input file.
 *
 * default behavior is to terminate the scanner.
 *
 * use option `noyywrap` to disable default behavior.
 */
%option noyywrap

%x IFILE

IFILE_start     ^#[ \t]*include[ \t]*[\"<]
IFILE_filename  [^ \t\n\">]+

%%

{IFILE_start} { BEGIN IFILE; }

<IFILE>{IFILE_filename} {
                          {
                            int c;
                            /* consume any blank chars or '>' after
                               the filename until end of line
                             */
                            while((c = input()) && c != '\n');
                          }
                          yylineno++;
                          /* setup new environment for using these rules repeatly */
                          if(!newfile(yytext))
                            yyterminate(); /* no such file */
                          BEGIN INITIAL;
                        }

<IFILE>.|\n {
              fprintf(stderr, "%4d bad include line\n", yylineno);
              yyterminate();
            }

<<EOF>> { /* <<EOF>> is a special rule */ 
          if(!popfile()) yyterminate();
        }

^.  { fprintf(yyout, "%-4d %s", yylineno, yytext); }
^\n { fprintf(yyout, "%-4d %s", yylineno++, yytext); }
\n  { ECHO; yylineno++; }
.   { ECHO; }

%%

int main(int argc, char **argv)
{
  if(argc < 2) {
    fprintf(stderr, "need filename\n");
    return 1;
  }
  if(newfile(argv[1]))
    yylex();
}

int newfile(char *fn)
{
  FILE *f = fopen(fn, "r");
  struct bufstack *bs = malloc(sizeof(struct bufstack));
  /* die if no file or no room */
  if(!f) { perror(fn); return 0; }
  if(!bs) { perror("malloc"); exit(1); }
  /* remember state */
  if(curbs) curbs->lineno = yylineno;
  bs->prev = curbs;
  /* set up current entry */
  bs->bs = yy_create_buffer(f, YY_BUF_SIZE);
  bs->f = f;
  bs->filename = fn;
  /* */
  yy_switch_to_buffer(bs->bs);
  curbs = bs;
  /* */
  yylineno = 1;
  curfilename = fn;
  return 1;
}

int popfile(void)
{
  struct bufstack *bs = curbs;
  struct bufstack *prevbs;
  if(!bs) return 0;
  /* get rid of current entry */
  fclose(bs->f);
  yy_delete_buffer(bs->bs);
  /* switch back to previous */
  prevbs = bs->prev;
  free(bs);
  if(!prevbs) return 0;
  yy_switch_to_buffer(prevbs->bs);
  curbs = prevbs;
  yylineno = curbs->lineno;
  curfilename = curbs->filename;
  return 1;
}
