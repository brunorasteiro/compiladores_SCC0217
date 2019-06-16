# syntactic analyser

## flex

### [docs](https://westes.github.io/flex/manual/index.html)

## bison

### [docs](https://www.gnu.org/software/bison/manual/bison.html#GLR-Parsers)

### LALG grammar: the “dangling else” ambiguity

When we run `make`:

```bash
bison.y: warning: 1 shift/reduce conflict [-Wconflicts-sr]
```

Explanation (taken from the [docs](https://www.gnu.org/software/bison/manual/bison.html#GLR-Parsers)):

#### 1.5 Writing GLR Parsers

In some grammars, Bison’s deterministic LR(1) parsing algorithm cannot decide whether to apply a certain grammar rule at a given point. That is, it may not be able to decide (on the basis of the input read so far) which of two possible reductions (applications of a grammar rule) applies, or whether to apply a reduction or read more of the input and apply a reduction later in the input. These are known respectively as reduce/reduce conflicts (see Reduce/Reduce), and shift/reduce conflicts (see Shift/Reduce).

#### 5.2 Shift/Reduce Conflicts

Suppose we are parsing a language which has if-then and if-then-else statements, with a pair of rules like this:

```Haskell
if_stmt:
  "if" expr "then" stmt
| "if" expr "then" stmt "else" stmt
;
```

Here "if", "then" and "else" are terminal symbols for specific keyword tokens.

When the "else" token is read and becomes the lookahead token, the contents of the stack (assuming the input is valid) are just right for reduction by the first rule. But it is also legitimate to shift the "else", because that would lead to eventual reduction by the second rule.

This situation, where either a shift or a reduction would be valid, is called a shift/reduce conflict. Bison is designed to resolve these conflicts by choosing to shift, unless otherwise directed by operator precedence declarations. To see the reason for this, let’s contrast it with the other alternative.

Since the parser prefers to shift the "else", the result is to attach the else-clause to the innermost if-statement, making these two inputs equivalent:

```Haskell
if x then if y then win; else lose;
```

if x then do; if y then win; else lose; end;
But if the parser chose to reduce when possible rather than shift, the result would be to attach the else-clause to the outermost if-statement, making these two inputs equivalent:

```Haskell
if x then if y then win; else lose;
```

if x then do; if y then win; end; else lose;
The conflict exists because the grammar as written is ambiguous: either parsing of the simple nested if-statement is legitimate. The established convention is that these ambiguities are resolved by attaching the else-clause to the innermost if-statement; this is what Bison accomplishes by choosing to shift rather than reduce. (It would ideally be cleaner to write an unambiguous grammar, but that is very hard to do in this case.) This particular ambiguity was first encountered in the specifications of Algol 60 and is called the “dangling else” ambiguity.

To avoid warnings from Bison about predictable, legitimate shift/reduce conflicts, you can use the %expect n declaration. There will be no warning as long as the number of shift/reduce conflicts is exactly n, and Bison will report an error if there is a different number. See Suppressing Conflict Warnings. However, we don’t recommend the use of %expect (except ‘%expect 0’!), as an equal number of conflicts does not mean that they are the same. When possible, you should rather use precedence directives to fix the conflicts explicitly (see Using Precedence For Non Operators).

The definition of if_stmt above is solely to blame for the conflict, but the conflict does not actually appear without additional rules. Here is a complete Bison grammar file that actually manifests the conflict:

```Haskell
%%
stmt:
  expr
| if_stmt
;

if_stmt:
  "if" expr "then" stmt
| "if" expr "then" stmt "else" stmt
;

expr:
  "identifier"
;
```

### yyerrok

#### 2.3 Simple Error Recovery

The Bison language itself includes the reserved word error, which may be included in the grammar rules. In the example below it has been added to one of the alternatives for line:

```Haskell
line:
  '\n'
| exp '\n'   { printf ("\t%.10g\n", $1); }
| error '\n' { yyerrok;                  }
;
```

This addition to the grammar allows for simple error recovery in the event of a syntax error. If an expression that cannot be evaluated is read, the error will be recognized by the third rule for line, and parsing will continue. (The yyerror function is still called upon to print its message as well.) The action executes the statement yyerrok, a macro defined automatically by Bison; its meaning is that error recovery is complete (see Error Recovery). Note the difference between yyerrok and yyerror; neither one is a misprint.

### 3.3.3 Recursive Rules

Consider this recursive definition of a comma-separated sequence of one or more expressions:

```Haskell
expseq1:
  exp
| expseq1 ',' exp
;
```

Since the recursive use of expseq1 is the leftmost symbol in the right hand side, we call this left recursion. By contrast, here the same construct is defined using right recursion:

```Haskell
expseq1:
  exp
| exp ',' expseq1
;
```

Any kind of sequence can be defined using either left recursion or right recursion, _**but you should always use left recursion, because it can parse a sequence of any number of elements with bounded stack space. Right recursion uses up space on the Bison stack in proportion to the number of elements in the sequence, because all the elements must be shifted onto the stack before the rule can be applied even once.**_ See The Bison Parser Algorithm, for further explanation of this.

### 3.7 Bison Declarations

**The first rule in the grammar file also specifies the start symbol, by default.** If you want some other symbol to be the start symbol, you must declare it explicitly (see Languages and Context-Free Grammars).

### 3.7.3 Operator Precedence

```Haskell
%left symbols…
%left <type> symbols…

%token OR "||"
%left OR "<="
```

And indeed any of these declarations serves the purposes of %token. But in addition, they specify the associativity and relative precedence for all the symbols:

- The associativity of an operator op determines how repeated uses of the operator nest: whether ‘x op y op z’ is parsed by grouping x with y first or by grouping y with z first. %left specifies left-associativity (grouping x with y first) and %right specifies right-associativity (grouping y with z first). %nonassoc specifies no associativity, which means that ‘x op y op z’ is considered a syntax error.
%precedence gives only precedence to the symbols, and defines no associativity at all. Use this to define precedence only, and leave any potential conflict due to associativity enabled.
- The precedence of an operator determines how it nests with other operators. All the tokens declared in a single precedence declaration have equal precedence and nest together according to their associativity. **When two tokens declared in different precedence declarations associate, the one declared later has the higher precedence and is grouped first.**

### 4.1 The Parser Function yyparse

You call the function yyparse to cause parsing to occur. This function reads tokens, executes actions, and ultimately returns when it encounters end-of-input or an unrecoverable syntax error. You can also write an action which directs yyparse to return immediately without reading further.

#### Function: int yyparse (void)
- The value returned by yyparse is 0 if parsing was successful (return is due to end-of-input).
- The value is 1 if parsing failed because of invalid input, i.e., input that contains a syntax error or that causes YYABORT to be invoked.
- The value is 2 if parsing failed due to memory exhaustion.
