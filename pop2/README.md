# POP-2 Grammar

[POP-2](https://en.wikipedia.org/wiki/POP-2) is a list-processing and
functional programming language designed by Robin Popplestone and Rod
Burstall at the University of Edinburgh, first implemented in 1968. It is
an ALGOL-like language built around an operand stack, with one famous
inversion: assignment is written `<expression> -> <variable>;` rather than
`<variable> := <expression>;` -- a value is evaluated (pushed) and then
flows left-to-right into its destination. POP-2 was the direct ancestor of
POP-11 and, through it, influenced later AI-oriented languages.

## Source

https://en.wikipedia.org/wiki/POP-2

## Specification

https://www.cs.utexas.edu/~moore/best-ideas/pltp/POP-2-Reference-Manual.pdf

This is a scanned copy of the original *POP-2 Reference Manual* by
R. M. Burstall and R. J. Popplestone (Department of Machine Intelligence
and Perception, University of Edinburgh). It is an image-based PDF (OCR
text extracted from it is noisy), but it is the authoritative primary
source and every construct below was checked against text extracted from
it with `pdftotext`.

## Notes

This grammar is built directly from the Reference Manual's own syntax
descriptions and worked examples (section numbers refer to that manual):

- Assignment (section 5.5): `<expression> -> <destination>`, where a
  destination is either a plain variable or an "updater" call such as
  `3 -> a(4);` (confirmed by the manual's own example).
- Function/lambda definition (section 4.1): `function <name> <params>;
  <body> end` for a named function (e.g. `function max x y; if x > y
  then x else y close end;`, taken verbatim from the manual) and
  `lambda <params>; <body> end` for an anonymous one; note that formal
  parameters are a plain space-separated list with **no** enclosing
  parentheses, matching the manual's examples.
- Conditionals (section 6.1): `if <cond> then <body> [elseif <cond> then
  <body>]* [else <body>] close` (the worked example
  `if x>0 and x<3 then y elseif x>3 then z else w close` is used verbatim
  as one of this grammar's test inputs).
- Labels and `goto` (section 5.4): a statement may be preceded by
  `<label>:`, and `goto <label>` transfers control to it. POP-2 has **no**
  `while`/`for`/`repeat` loop keywords -- the manual's own example shows
  looping built entirely from a label and a conditional `goto`
  (`loop: x+1->x; y*y->y; if x=0 then goto loop close`), and this grammar
  models nothing beyond that.
- Comments (section 5.6): "The word `comment` and all characters after it
  up to and including the next semicolon are ignored" -- quoted directly
  from the manual and modeled exactly that way (not a symbolic comment
  marker like `//` or `#`).
- Lists (section 8.3): a list *constant* is written with space-separated
  elements in square brackets and may nest, e.g. `[1 2 DOG CAT]` or
  `[[1 2][4 5]6]` (both taken verbatim from the manual). A list
  *expression* -- built dynamically via `cons` -- is written
  `[% <expr>, <expr>, ... %]` (e.g. `[% x+1, x+2, x+3 %]`, also verbatim).
- Partial application (section 4.4) uses the same `%`-decorated
  parenthesis convention: `f(% <args> %)`.
- Numeric literals (section 2.3): decimal integers, an octal form
  `8:<octal digits>`, a binary form `2:<binary digits>`, and reals such as
  `.5`, `1.99`, with an optional `10+<n>`/`10-<n>` exponent suffix written
  with no intervening space (e.g. `1.510+6`) -- all taken from the
  manual's own `<integer>`/`<real>` syntax rules.
- `and`, `or`, and `not` (sections 2.4/6, confirmed in the manual's own
  example text, e.g. `if hd(l) or null(solidified(l)) then ...`) are
  modeled as keywords; `true`, `false`, and `nil` are **not** special
  literals in POP-2 -- the manual states they are ordinary standard
  *variables* (bound to the integers `1`, `0`, and the null list,
  respectively), so this grammar treats them as plain identifiers.
- Deliberately not modeled: the manual's extremely permissive identifier
  syntax, under which a run of "sign" characters alone (e.g. `+++`, `*`,
  `$$*`) can itself be a valid identifier -- supporting that would make
  tokenization ambiguous with this grammar's operators, so identifiers
  here are restricted to the conventional letter-starting alphanumeric
  form. User-declared operator precedence (`vars ... operation <n> ...`),
  multi-destination assignment beyond a simple list, records/arrays
  beyond the single `updater`-call form shown above, and the exact
  character set used for "words" as opposed to double-quoted word
  constants are also out of scope.

Entry rule: `program`.

## Examples

The `examples/` directory contains 10 POP-2 programs exercising: a basic
word assignment and function call, the reversed `->` assignment operator
across all four numeric literal forms (decimal, octal, binary, real with
exponent), a named `function` definition (the manual's own `max` example),
an anonymous `lambda` expression assigned to a variable, an
`if`/`elseif`/`else`/`close` conditional (the manual's own worked
example), a labelled loop driven by `goto` (also taken from the manual),
a nested list constant, a dynamically-built list expression (`[% ... %]`),
an array/updater-style assignment (`3 -> a(4);`), and partial application
(`f(% y1, z1 %)`).
