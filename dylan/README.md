# Dylan Grammar

[Dylan](https://en.wikipedia.org/wiki/Dylan_(programming_language)) is a
multi-paradigm (functional and object-oriented), dynamic, reflective
programming language originally designed in the early 1990s at Apple
Computer, with later development by Harlequin and Carnegie Mellon
University. It has an ALGOL-like infix syntax (derived from an earlier
s-expression prefix form related to Scheme/Common Lisp) and a generic-
function / multiple-dispatch object system similar to CLOS. The main
active implementation today is [Open Dylan](https://opendylan.org/).

## Source

https://opendylan.org/

## Specification

https://opendylan.org/books/drm/ (the "Dylan Reference Manual", the
language's canonical specification, published 1998 by Apple/Harlequin via
Addison-Wesley and now hosted by the Open Dylan project)

See also the more approachable https://opendylan.org/documentation/intro-dylan/
tutorial, and https://en.wikipedia.org/wiki/Dylan_(programming_language)
for a general overview.

## Notes

This grammar covers the core forms described in the DRM: `define library`,
`define module`, `define class` (slots, keyword specs, inherited specs),
`define generic`, `define method`, `define function` (an Open Dylan
extension, not in the DRM itself, but in widespread use -- see DEP-0002),
`define variable`/`define constant`, `define domain`, the statement forms
(`if`/`elseif`/`else`, `unless`, `while`, `until`, `for`, `case`, `select`,
`block`/`exception`/`cleanup`/`afterwards`, `begin`), `let` bindings
(including multiple-value and `#rest` forms), `local` method definitions,
infix/unary expressions with the DRM's operator-precedence table, keyword
and positional function calls, slot (`.slot`) and element (`[]`) reference
syntax, and the literal forms (`#t`/`#f`, lists `#( )`, vectors `#[ ]`,
unique-string symbols `#"sym"`, keyword symbols `name:`, numbers, strings,
and characters).

A few deliberate simplifications, made because the DRM's own lexical
grammar is unusually permissive and context-sensitive for a token stream
that a conventional ANTLR lexer can reproduce exactly:

- The DRM reserves words like `class`, `method`, `if`, `for`, etc. only in
  certain syntactic positions, in principle allowing them to otherwise be
  used as ordinary identifiers. This grammar reserves them everywhere, as
  is conventional practice for grammars in this repo and most other Dylan
  tooling; no example program here relies on using a reserved word as a
  plain identifier.
- Nested block comments (`/* /* ... */ ... */`) are mentioned in the DRM's
  lexical BNF but are matched here with a simple, non-nesting
  `/* ... */` rule, since ANTLR lexer rules cannot express arbitrary
  nesting depth directly.
- The DRM's operator-precedence table (Table 4-1) has a known errata gap
  around where `:=` sits in the ordering (a missing horizontal rule in the
  printed book); this grammar treats `:=` as the lowest-precedence,
  right-associative operator, which matches its use as the DRM's example
  code shows it (`x := expr`, never nested inside another operator
  expression).
- `define macro` (Dylan's own macro-definition facility, with its
  pattern/template rule syntax) is not implemented -- the DRM's own
  grammar for macro patterns is itself a distinct sub-language, and no
  example macro definitions were available to validate a grammar for it
  against.

Entry rule: `program`.

## Examples

The `examples/` directory contains 10 Dylan programs, each adapted from
constructs shown directly in the DRM or the Wikipedia article (for
example, the `<point>` class and `factorial` function), exercising:
library/module headers, class definitions (slots, keywords, inheritance),
generic functions and methods (including operator methods like `\+`),
variable/constant definitions, `case` statements, `if`/`select`
statements, `for` loops, `while`/`until` loops, `block`/`local`/multiple
values, and the full range of literal syntax.
