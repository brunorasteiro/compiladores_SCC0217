syntax = src/syntax.y
lex = src/lex.l

all: $(syntax) $(lex)
	lex $(lex)
	yacc -d $(syntax)
	gcc lex.yy.c y.tab.c -o syntactic-analyzer
