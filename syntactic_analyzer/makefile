syntax = syntax.y
lex = lex.l

all: src/$(syntax) src/$(lex)
	cd src && yacc -d $(syntax)
	cd src && lex $(lex)
	cd src && gcc lex.yy.c y.tab.c -o ../syntactic-analyzer

lex:
	cd src; \
		bison bison.y -d --file-prefix=y; \
		flex flex.l; \
		gcc flex.test.c lex.yy.c -o ../lexical-analyzer; \
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

clean:
	cd src && rm -f lex.yy.c y.tab.c y.tab.h
	rm -f lexical-analyzer syntactic-analyzer
