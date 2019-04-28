#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned long hashstring(unsigned char *str)
{
    unsigned long hash = 5381;
    int c;

    while (c = *str++)
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */

    return hash;
}
int searchNode(char** hashtable, int load, char* word) {
    int hash = hashstring(word) % load;
    while (hashtable[hash] != NULL){
        if (strcmp(hashtable[hash], word) != 0)
            hash++;
        else
            return 1;
    }
    return 0;

}

void insertNode(char** hashtable, int load, char* word) {
    int hash = hashstring(word) % load;
    // printf("%10s %d\n", word, hash);
    while (hashtable[hash] != NULL)
        hash = (++hash) % load;
    hashtable[hash] = word;
    return;
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

    // Initialize hashtable
    char** hashtable = (char**) malloc(load * sizeof(char*));
    for (int i = 0; i < load; i++) {
        hashtable[i] = NULL;
    }

    // Insert keywords
    for (int i = 0; i < n; i++) {
        char* word = keywords[i];
        insertNode(hashtable, load, word);
    }

    // Uncomment below to search the keywords
    // for (int i = 0; i < n; i++) {
    //     char* word = keywords[i];
    //     int ans = searchNode(hashtable, load, word);
    //     if (ans)
    //         printf("%d - %s (ok)\n", i, word);
    // }

    // Test other words
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
    // Uncomment below to search once for the identifiers 
    // for (int i = 0; i < n; i++) {
    //     char* word = identifiers[i];
    //     int ans = searchNode(hashtable, load, word);
    //     if (ans)
    //         printf("oh no! :(\n"); // print only if return true by mistake
    // }

    printf("Testing 32 words 1000000 times.\n");
    for (int j = 0; j < 1000000; j++) {
        for (int i = 0; i < n; i++) {
            searchNode(hashtable, load, keywords[i]);
            searchNode(hashtable, load, identifiers[i]);
        }
    }

    printf("Done.");


    
    
    return 0;
}
