all: src/flex.l src/bison.y
	make syntactic --no-print-directory

lexical: src/flex.l src/bison.y src/flex.test.c
	cd src; \
		bison bison.y -d --file-prefix=y --debug; \
		flex flex.l; \
		gcc flex.test.c lex.yy.c -o ../lexical-analyser; \
		rm -f lex.yy.c y.tab.h y.tab.c

syntactic: src/flex.l src/bison.y
	cd src; \
		bison bison.y -d --file-prefix=y --debug; \
		flex flex.l; \
		gcc y.tab.c lex.yy.c -o ../syntactic-analyser; \
		rm -f lex.yy.c y.tab.h y.tab.c

analyse-grammar:
	@cd src; \
		bison bison.y -d --file-prefix=y --debug --verbose; \
		cat y.output; \
		rm -f y.output y.tab.h y.tab.c;

ntests=$(shell ls tests/lexical/*input.txt | wc -w)
test-lexical:
	@echo "Testing lexer... (found $(ntests) tests)"
	make lexical --no-print-directory
	@for test_input in tests/lexical/*input.txt; do \
		i=$$(echo $$test_input | grep -oE '[0-9]+'); \
		(./lexical-analyser $$test_input 2>&1) > .output.txt; \
		(diff -b .output.txt tests/lexical/$${i}output.txt 2>&1) > /dev/null && printf "\ttest #$${i}\t\t** PASS **\n" || printf "\ttest #$${i}\t\t** FAIL **\n"; \
	done
	@rm .output.txt
	rm lexical-analyser

ntests_syn=$(shell ls tests/syntactic/*input.txt | wc -w)
test-syntactic:
	@echo "Testing syntactic analyser... (found $(ntests_syn) tests)"
	make syntactic --no-print-directory
	@for test_input in tests/syntactic/*input.txt; do \
		i=$$(echo $$test_input | grep -oE '[0-9]+'); \
		(./syntactic-analyser $$test_input 2>&1) > .output.txt; \
		(diff -b .output.txt tests/syntactic/$${i}output.txt 2>&1) > /dev/null && printf "\ttest #$${i}\t\t** PASS **\n" || printf "\ttest #$${i}\t\t** FAIL **\n"; \
	done
	@rm .output.txt
	rm syntactic-analyser

clean:
	cd src && rm -f lex.yy.c y.tab.c y.tab.h
	rm -f lexical-analyser syntactic-analyser
