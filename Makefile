calc2: 07_calc.l 07_calc.y 07_calc.h
	bison -d -t 07_calc.y
	flex -o 07_calc.lex.c 07_calc.l
	cc -o $@ 07_calc.tab.c 07_calc.lex.c 07_calc.c -lfl

concordance: 06_concordance.l
	flex $<
	cc -o $@ lex.yy.c -lfl

wc2: 05_wc2.l
	flex $<
	cc -o $@ lex.yy.c -lfl

wc1: 05_wc1.l
	flex $<
	cc -o $@ lex.yy.c -lfl

fstring: 04_fstring.l
	flex $<
	cc -o $@ 04_fstring.c -lfl

calc: 03_calc.l 03_calc.y
	bison -d -t 03_calc.y
	flex 03_calc.l
	cc -o $@ 03_calc.tab.c lex.yy.c -lfl

lexonly: 02_lex_only.l
	flex $<
	cc -o $@ lex.yy.c -lfl

hello: 01_hello.l
	flex $<
	cc -o $@ lex.yy.c -lfl

clean:
	@rm -rf lexonly calc lex.yy.c *.tab.c *.tab.h hello \
		fstring 04_fstring.c wc1 wc2 concordance calc2 \
		07_calc.lex.c
