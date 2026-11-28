# COWSEL Grammar

[COWSEL](https://en.wikipedia.org/wiki/COWSEL) (**CO**ntrolled **W**orking
**S**pac**E** **L**anguage) is a list-processing language designed by Robin
Popplestone (with Rod Burstall) between 1964 and 1966 at the University of
Edinburgh, based on a reverse-Polish (postfix) form of Lisp combined with
ideas from CPL. COWSEL was renamed POP-1 in 1966, and its lineage
continued through POP-2 and POP-11 (both also in this repo, as `pop2` and
`pop11`), making it the common ancestor of that whole family -- including
their shared, distinctive reversed assignment operator, `-> variable`.

## Source

https://en.wikipedia.org/wiki/COWSEL

## Specification

COWSEL has essentially no accessible documentation online. Its Wikipedia
article is a one-paragraph stub, flagged as relying on a single source
(an unpublished 1966 Edinburgh technical report, "EPU-R-12"), and no other
primary or secondary source describing its syntax could be found. The
*entire* syntax evidence available for this grammar is one worked example
quoted in that stub article:

```
function member
lambda x y
comment Is x a member of list y;
define y atom then *0 end
y hd x equal then *1 end
y tl -> y repeat up
```

https://en.wikipedia.org/wiki/COWSEL

## Notes

Given how little COWSEL is documented, this grammar should be read as a
best-effort reconstruction from a single example rather than a verified
transcription of a specification -- there is no specification to verify
it against. What follows is a careful accounting of what that one example
actually shows versus what was inferred to make a usable grammar:

**Directly shown by the example:**
- `function <name>` and `lambda <params>` introduce a function
  definition; parameters are a plain space-separated list.
- `comment ... ;` -- the word `comment` and everything up to and
  including the next semicolon is ignored. (This is the exact convention
  later written up explicitly in the POP-2 Reference Manual, so COWSEL
  appears to be where it originates.)
- Expressions are postfix/reverse-Polish: operands and function names are
  simply juxtaposed (`y hd` = `hd(y)`; `y hd x equal` = `equal(hd(y), x)`).
- `-> <variable>` is a postfix assignment (`y tl -> y`), the same operator
  POP-2 and POP-11 later inherited unchanged.
- `<test> then <body> end` is some form of conditional.
- `repeat` and `up` appear as bare, argument-less statements (loop back /
  return-from-function, by analogy with the rest of the POP family).

**Inferred, and explicitly uncertain:**
- The role of `define`: it introduces the *first* conditional in the
  example (`define y atom then *0 end`) but not the *second*
  (`y hd x equal then *1 end`), which is otherwise syntactically
  identical. This grammar resolves that by making `define` an **optional**
  leading keyword on every conditional (`conditional: DEFINE? expr THEN
  stmt* END`), simply because that is what the one example shows -- its
  exact semantic role (if any) is unknown.
- The meaning of `*0` and `*1`: modeled here as a distinct "literal
  integer" token (`*` immediately followed by digits), on the guess that
  it is some kind of quoted/literal-number marker distinguishing a literal
  from an identifier in a stack language. This is a guess, not a
  confirmed reading.
- Whether a function definition has an explicit closing keyword: the
  example's function body simply ends at `up` with nothing further, so
  this grammar treats a function definition as running until the next
  `function` keyword or end of file, with no dedicated closer.
- This grammar does not track the arity of any postfix operator (`atom`,
  `hd`, `tl`, `equal`, `plus`, ...) -- an expression is just "one or more
  terms in a row" syntactically, since the grammar has no way to know how
  many operands a given word consumes.

Entry rule: `program`.

## Examples

The `examples/` directory contains 10 COWSEL programs. The first,
`member.cow`, is the Wikipedia article's own example, reproduced verbatim.
The remaining nine are synthetic programs written to exercise the same
constructs more broadly (and are **not** claimed to be authentic COWSEL
source, since no further authentic COWSEL source could be found): a
minimal function, a `define`-prefixed conditional, a bare (no-`define`)
conditional, a chain of `->` assignments, the `*N` literal-marker form, a
nested conditional, multiple function definitions in one file, a
`comment ... ;` statement, and a `repeat`-driven loop.
