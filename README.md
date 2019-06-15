# Compiladores SCC0217

Repositório destinado aos trabalhos em grupo da disciplina Linguagens de Programação e Compiladores (SCC0217)

## LALG lexical parser

First install flex, then:

```bash
make
# Writes output to stdout and to $PWD/output.txt
./lex < input-lalg-program.txt
```

Run unit tests:

```bash
make test
```
