calc: calc.l calc.y
	bison -d -t calc.y
	flex calc.l
	cc -o $@ calc.tab.c lex.yy.c -lfl

