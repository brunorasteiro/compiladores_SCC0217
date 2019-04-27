all: src/lex.l
	flex -o src/lex.yy.c src/lex.l
	gcc -g src/lex.yy.c -lfl -o lex

test:
	@echo "test"

clean:
	rm src/lex.yy.c || true
	rm lex || true
	rm output.txt || true
