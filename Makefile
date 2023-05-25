fstring: fstring.l
	flex $<
	cc -o $@ fstring.c -lfl

lexonly: lex_only.l
	flex $<
	cc -o $@ lex.yy.c -lfl

calc: calc.l calc.y
	bison -d -t calc.y
	flex calc.l
	cc -o $@ calc.tab.c lex.yy.c -lfl

hello: hello.l
	flex $<
	cc -o $@ lex.yy.c -lfl

clean:
	@rm -rf lexonly calc lex.yy.c *.tab.c *.tab.h hello fstring fstring.c
