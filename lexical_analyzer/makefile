run: src/lex.l
	@flex -o src/lex.yy.c src/lex.l 
	@gcc -g src/lex.yy.c -lfl -o bin/prog
	@bin/prog < ./input/input_0.txt