# Short Code Grammar

[Short Code](https://en.wikipedia.org/wiki/Short_Code_(computer_language))
(also "Short Order Code", originally "Brief Code") is one of the
earliest higher-level programming languages for an electronic computer,
proposed by John Mauchly in 1949 and implemented by William Schmitt --
first for the BINAC in 1949, then for the UNIVAC I in 1950, where it
became known as Short Code. Unlike machine code, its statements
represented ordinary mathematical expressions; the source was not
compiled but interpreted at roughly 50 times the cost of equivalent
machine code.

## Source

https://en.wikipedia.org/wiki/Short_Code_(computer_language)

## Specification

No Short Code language reference could be located and read. The
Wikipedia article above cites William F. Schmitt, "The UNIVAC Short
Code," *Annals of the History of Computing* 10 (1988), pp. 7-8, 15, and
a History of Programming Languages conference entry
(`hopl.info/showlanguage.prx?exp=2707&language=SHORT%20CODE`), as the
sources for how expressions were converted into code, but neither could
be fetched (the HOPL link's TLS certificate has expired; the Annals
article is not online). This grammar is built entirely from the one
worked example shown in the Wikipedia article, which is consequently
also the only source for every syntax detail below.

## Notes

**What Short Code's documented example actually shows, and why this
grammar only covers that:** the Wikipedia article's single worked
example converts the algebraic formula `a = (b + c) / b * c` in three
steps:

```
X3 =  (  X1 +  Y1 )  /  X1 * Y1     substitute variables
X3 03 09 X1 07 Y1 02 04 X1   Y1     substitute operators and parentheses
07Y10204X1Y1                        group into 12-character words
0000X30309X1
```

The *first* step -- substituting Short Code's own `X`/`Y`-numbered
variable names into an otherwise completely ordinary infix mathematical
expression (`=`, parentheses, `+`, `/`, `*`) -- is what this grammar
models, since it is the only human-facing notation shown anywhere. The
*second* and *third* steps are a two-digit numeric encoding of operators
and parentheses, done "by hand" according to the article (a manual
conversion process, not something a programmer wrote directly), and then
a packing of those codes into the UNIVAC's 12-character machine words.
No table mapping codes like `03`, `09`, `02`, `04`, `07` to specific
operators/parentheses is given anywhere in the sources read, so this
encoding stage is entirely out of scope for this grammar -- it is
effectively Short Code's "object code," analogous to not writing a
grammar for raw assembled machine instructions when documenting a
higher-level language's source syntax.

**Confirmed directly:**
- Variables are named with a letter -- `X` or `Y` in the one example --
  followed by a digit (`X1`, `Y1`, `X3`).
- Multiplication could be written by mere juxtaposition of two
  expressions with no operator between them -- confirmed explicitly:
  "Multiplication is written by juxtaposition, with no operator code."
  (This is stated of the two-digit encoded form specifically, but since
  the human-notation line of the example still shows an explicit `*`,
  this grammar accepts both an explicit `*` and bare juxtaposition as
  equivalent, documented as a reasonable but not separately confirmed
  extrapolation.)
- `+`, `/`, and parentheses are used exactly as in ordinary algebra.

**Reconstructed, since the article shows no further examples:**
- Subtraction (`-`) and numeric literals are not shown in the one
  worked example, but are included here as an unremarkable, almost
  certainly necessary extension for any arithmetic-expression language,
  consistent with everything that *is* confirmed.
- A bare expression with no assignment (no `VAR =` prefix) is accepted
  as an alternative statement form, though the only documented example
  is an assignment; this is speculative.
- One statement per line is assumed, since the article describes no
  statement terminator or separator.

**Explicitly not modeled, for lack of any confirmed syntax:** branching
and calls into "a library of functions" are both mentioned by name in
the Wikipedia article, with no syntax given for either, so neither is
implemented here. No comment syntax is documented, so none is
implemented.

Entry rule: `program`.

## Examples

The `examples/` directory contains 10 Short Code programs: the
Wikipedia article's own worked example (`X3 = (X1 + Y1) / X1 * Y1`);
juxtaposition-multiplication; subtraction; nested parentheses; a unary
minus; a bare (unassigned) expression; several assignment statements in
sequence; a numeric literal; a chained division; and a quadratic-formula
style expression combining juxtaposition, nested parentheses, and unary
minus together.
