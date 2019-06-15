sintaxe = sintaxe.y
lexico = lex.l
hellomake: $(sintaxe) $(lexico)
	yacc -d $(sintaxe)
	lex $(lexico)
	gcc lex.yy.c y.tab.c -o run
