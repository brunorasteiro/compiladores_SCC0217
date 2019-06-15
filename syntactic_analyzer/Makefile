syntax = src/syntax.y
lex = src/lex.l

all: $(syntax) $(lex)
	yacc -d $(syntax)
	lex $(lex)
	gcc lex.yy.c y.tab.c -o syntactic-analyzer
