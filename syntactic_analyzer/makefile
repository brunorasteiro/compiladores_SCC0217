all: src/flex.l src/bison.y
	@echo "TODO: all"
	@# cd src && yacc -d $(syntax)
	@# cd src && lex $(lex)
	@# cd src && gcc lex.yy.c y.tab.c -o ../syntactic-analyser

lex: src/flex.l src/bison.y src/main.flex.c
	cd src; \
		bison bison.y -d --file-prefix=y --debug; \
		flex flex.l; \
		gcc main.flex.c lex.yy.c -o ../lexical-analyser; \
		rm -f lex.yy.c y.tab.h y.tab.c

ntests=$(shell ls tests/lex/*input.txt | wc -w)
test-lex:
	@echo "Testing lexer... (found $(ntests) tests)"
	make lex --no-print-directory
	@for test_input in tests/lex/*input.txt; do \
		i=$$(echo $$test_input | grep -oE '[0-9]+'); \
		(./lexical-analyser $$test_input 2>&1) > .output.txt; \
		(diff -b .output.txt tests/lex/$${i}output.txt 2>&1) > /dev/null && echo "\ttest #$${i}\t\t** PASS **" || echo "\ttest #$${i}\t\t** FAIL **"; \
	done
	@rm .output.txt
	rm lexical-analyser

syn: src/flex.l src/bison.y
	cd src; \
		bison bison.y -d --file-prefix=y --debug; \
		flex flex.l; \
		gcc y.tab.c lex.yy.c -o ../syntactic-analyser; \
		rm -f lex.yy.c y.tab.h y.tab.c

ntests_syn=$(shell ls tests/syn/*input.txt | wc -w)
test-syn:
	@echo "Testing syntactic analyser... (found $(ntests_syn) tests)"
	make syn --no-print-directory
	@for test_input in tests/syn/*input.txt; do \
		i=$$(echo $$test_input | grep -oE '[0-9]+'); \
		(./syntactic-analyser $$test_input 2>&1) > .output.txt; \
		(diff -b .output.txt tests/syn/$${i}output.txt 2>&1) > /dev/null && echo "\ttest #$${i}\t\t** PASS **" || echo "\ttest #$${i}\t\t** FAIL **"; \
	done
	@rm .output.txt
	rm syntactic-analyser

analyse-grammar:
	@cd src; \
		bison bison.y -d --file-prefix=y --debug --verbose; \
		cat y.output; \
		rm -f y.output y.tab.h y.tab.c;

clean:
	cd src && rm -f lex.yy.c y.tab.c y.tab.h
	rm -f lexical-analyser syntactic-analyser
