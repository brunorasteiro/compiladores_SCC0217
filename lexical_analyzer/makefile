all: src/lex.l
	flex -o src/lex.yy.c src/lex.l
	gcc -g src/lex.yy.c -lfl -o lex

ntests=$(shell ls tests/*input.txt | wc -w)
test: all
	@echo "Testing lexer... (found $(ntests) tests)"
	@for (( i=0; i < $(ntests); i++ )); do \
		./lex < tests/$${i}input.txt > .output.txt; \
		cmp -s .output.txt tests/$${i}output.txt && echo -e "\ttest #$${i}\t\t** PASS **" || echo -e "\ttest #$${i}\t\t** FAIL **"; \
	done
	@rm .output.txt

clean:
	rm src/lex.yy.c || true
	rm lex || true
	rm output.txt || true
