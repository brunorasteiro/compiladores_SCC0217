all: src/flex.l src/bison.y
	@echo "TODO: all"
	@# cd src && yacc -d $(syntax)
	@# cd src && lex $(lex)
	@# cd src && gcc lex.yy.c y.tab.c -o ../syntactic-analyzer

lex: src/flex.l src/bison.y src/main.flex.c
	cd src; \
		bison bison.y -d --file-prefix=y; \
		flex flex.l; \
		gcc main.flex.c lex.yy.c -o ../lexical-analyzer; \
		rm -f lex.yy.c y.tab.h y.tab.c

ntests=$(shell ls tests/lex/*input.txt | wc -w)
test-lex:
	@echo "Testing lexer... (found $(ntests) tests)"
	make lex --no-print-directory
	@for (( i=0; i < $(ntests); i++ )); do \
		./lexical-analyzer tests/lex/$${i}input.txt > .output.txt; \
		diff -b .output.txt tests/lex/$${i}output.txt && echo -e "\ttest #$${i}\t\t** PASS **" || echo -e "\ttest #$${i}\t\t** FAIL **"; \
	done
	@rm .output.txt
	rm lexical-analyzer

syn: src/flex.l src/bison.y
	cd src; \
		bison bison.y -d --file-prefix=y; \
		flex flex.l; \
		gcc y.tab.c lex.yy.c -o ../syntactic-analyzer; \
		rm -f lex.yy.c y.tab.h y.tab.c

test-syn:
	@echo "TODO: test syn analyzer"

clean:
	cd src && rm -f lex.yy.c y.tab.c y.tab.h
	rm -f lexical-analyzer syntactic-analyzer
