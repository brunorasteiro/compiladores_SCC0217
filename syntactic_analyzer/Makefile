syntax = syntax.y
lex = lex.l

all: src/$(syntax) src/$(lex)
	cd src && yacc -d $(syntax)
	cd src && lex $(lex)
	cd src && gcc lex.yy.c y.tab.c -o ../syntactic-analyzer
	
