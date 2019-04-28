#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int automaton(char* s) {
    /* Automaton to check if s is a reserved words. */
    if (*s == 'b') {
        return strcmp(s + 1, "egin") == 0;
    } else if (*s == 'c') {
        return strcmp(s + 1, "onst") == 0;
    } else if (*s == 'd') {
        return strcmp(s + 1, "o") == 0;
    } else if (*s == 'e') {
        return strcmp(s + 1, "nd") == 0;
    } else if (*s == 'f') {
        return strcmp(s + 1, "or") == 0;
    } else if (*s == 'i') {
        if (*(++s) == 'f') {
            return *(s + 1) == '\0';
        } else {
            return strcmp(s, "nteger") == 0;
        }
    } else if (*s == 'p') {
        if (*(++s) == 'r') {
            if (*(++s) == 'o') {
                if (*(++s) == 'c') {
                    return strcmp(s + 1, "edure") == 0;
                } else if (*s == 'g') {
                    return strcmp(s + 1, "ram") == 0;
                }
            }
        }
    } else if (*s == 'r') {
        if (*(++s) == 'e') {
            if (*(++s) == 'a') {
                if (*(++s) == 'd') {
                    return *(s + 1) == '\0';
                } else if (*s == 'l') {
                    return *(s + 1) == '\0';
                }
            }
        }
    } else if (*s == 't') {
        return *(s + 1) == 'o';
    } else if (*s == 'v') {
        return strcmp(s + 1, "ar") == 0;
    } else if (*s == 'w') {
        if (*(++s) == 'h') {
            return strcmp(s + 1, "ile") == 0;
        } else if (*s == 'r') {
            return strcmp(s + 1, "ite") == 0;
        }
    }

    return 0;
}

int main()
{
    int n = 16; // number of words
    int load = 100000;
	char* keywords[] = {
        "begin",
        "const",
        "do",
        "else",
        "end",
        "for",
        "if",
        "integer",
        "procedure",
        "program",
        "read",
        "real",
        "to",
        "var",
        "while",
        "write"
	};

    char* identifiers[] = {
        "x",
        "myvar",
        "curr",
        "temp",
        "i",
        "j",
        "total",
        "myfunction",
        "reduce",
        "sum",
        "first",
        "last",
        "result",
        "word",
        "ans",
        "count"
	};

    printf("Testing 32 words 1000000 times.\n");
    for (int j = 0; j < 1000000; j++) {
        for (int i = 0; i < n; i++) {
            automaton(keywords[i]);
            automaton(identifiers[i]);
        }
    }
    printf("Done.");


    
    
    return 0;
}
