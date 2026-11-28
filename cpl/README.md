# CPL Grammar

[CPL](https://en.wikipedia.org/wiki/CPL_(programming_language))
(Combined Programming Language, originally "Cambridge Programming
Language") was developed from 1962-1966 at the University of Cambridge
Mathematical Laboratory and the University of London Computer Unit by
Christopher Strachey, David Barron, and others, strongly influenced by
ALGOL 60. It was never fully implemented in the 1960s, but it is a
direct ancestor of BCPL -- Martin Richards built BCPL by stripping CPL
down to "all the difficult bits removed" -- and so, through BCPL, of B
and ultimately C.

## Source

https://en.wikipedia.org/wiki/CPL_(programming_language)

## Specification

CPL's own primary documentation -- Barron, Buxton, Hartley, Nixon &
Strachey, "The Main Features of CPL" (*The Computer Journal* 6(2), 1963)
and the CPL Working Papers -- could not be read as text: the only
reachable scanned copies,
http://www.ancientgeek.org.uk/CPL/CPL_Elementary_Programming_Manual.pdf
and http://www.ancientgeek.org.uk/CPL/CPL_Working_Papers.pdf, are
page-image scans with no OCR text layer. This grammar is instead built
primarily from Martin Richards, ["How BCPL evolved from
CPL"](https://www.cl.cam.ac.uk/~mr10/cpl2bcpl.pdf) (*The Computer
Journal*, 2011) -- a retrospective by BCPL's own designer that quotes
several genuine fragments of CPL source and explicitly distinguishes
CPL's original syntax from BCPL's later simplifications -- together with
the one CPL code example on the Wikipedia page above (a reconstruction
by Peter Norvig, not original 1960s source, used only for its control-
flow and `value of`/`result is` spelling).

## Notes

Because no primary CPL manual could be read, this grammar leans heavily
on one 2011 retrospective paper plus a single modern reconstruction.
Several points are confirmed directly by Richards' paper; others are
reconstructed, inconsistent between sources, or left out entirely.
Treat this grammar with more caution than most others in this repo:

- **Section brackets.** Richards states directly: "CPL used a section
  symbol (§) to be equivalent to Algol's BEGIN and a section symbol
  overprinted with a slash to represent END." This grammar implements
  that literally, using the Unicode section sign (`§`, U+00A7) for the
  opening bracket and the section sign combined with the Unicode
  combining long solidus overlay (`§̸`, U+00A7 U+0338) for the closing
  bracket -- as close an ASCII-text rendering of "a section symbol
  overprinted with a slash" as is practical. Curly braces (`{` `}`) are
  also accepted as an equivalent, easier-to-type alternative, since
  Richards notes that CPL/BCPL programmers moved to curly braces once
  they became available on their terminals.
- **Identifiers.** Richards states directly: "In CPL an identifier was
  either a lower case letter or an uppercase letter followed by letters,
  digits and dots, both sorts of names could be optionally followed by
  primes." This grammar implements that rule exactly -- so a lower-case
  *multi*-letter name is not a valid CPL identifier; only a single
  lower-case letter, or an upper-case-led word, is. This also means
  juxtaposed single-letter names were apparently read as implied
  multiplication in real CPL (Richards' example "`xx` means x multiplied
  by itself"); this grammar does **not** support that notational
  convention, since distinguishing it from a plain two-letter lowercase
  identifier is impossible without symbol-table information unavailable
  to a context-free grammar -- write explicit `x*x` instead.
- **Function calls vs. subscripts.** Richards' prose states that "CPL
  used square brackets for both function arguments and array
  subscripts," which BCPL later split into parentheses (calls) versus
  square brackets (subscripts). However, the one CPL function-definition
  fragment quoted in the very same paper (`let rec fact(n) = ...`) and
  the Wikipedia `Max(Items, ValueFunction)` example both use
  parentheses. This is an unresolved inconsistency between the paper's
  direct rule and its own quoted example, so this grammar accepts
  **both** parentheses and square brackets, interchangeably, for calls
  and for subscripts.
- **Declarations.** `let` introduces one or more bindings (optionally
  joined with `and`, and optionally prefixed with `rec` for a
  recursively-defined function): by value (`let x, y = 1, 2`), by
  reference (`let a, b ≃ x, y`, using `≃`, U+2243, confirmed as CPL's
  reference-declaration operator), or by substitution/"name"
  (`let w ≡ x*x + y*y`, using `≡`, U+2261, re-evaluated on every use).
  `let D in C` scopes declaration `D` to the single declaration or
  command `C` that follows. A trailing `E where D` (on an expression or
  a command) is the reverse: `D` is scoped to `E`, confirmed by Richards
  as "a where declaration ... qualified the largest declaration, command
  or expression to its left."
- **`value of` / `result is`.** Confirmed only via the Wikipedia/Norvig
  example, spelled as two words each (`value of`, `result is`), unlike
  BCPL's contracted `VALOF`/`RESULTIS`.
- **`LV` and `@`.** Richards confirms `@` is "the modern replacement of
  LV to compute the Lvalue of a variable," implying original CPL used
  the keyword `LV` as a prefix address-of operator; this grammar accepts
  both.
- **`!`** is both a dyadic (`v!p`, indirect/vector indexing) and monadic
  (`!p`, pointer dereference) operator, per Richards' `p,v!p:=p+1,p`
  simultaneous-assignment example.
- **Control-flow commands** (`if`/`then`/`else`, `test`/`then`/`or`,
  `while`/`do`, `until`/`do`, `repeat`, `for`/`to`/`by`/`do`) and the
  conditional expression form (`cond -> e1, e2`) are modeled on
  Richards' statement that BCPL's "IF, TEST, WHILE, UNTIL, REPEAT,
  REPEATWHILE, and REPEATUNTIL are all present [in CPL], although some
  (particularly the FOR command) were simplified [in BCPL]" -- i.e.
  these commands existed in CPL too, but CPL's own exact keyword casing
  is unconfirmed (BCPL's fragments are capitalized, but Richards notes
  CPL instead typographically *underlined* system words, which has no
  plain-text equivalent); this grammar uses lower-case spelling, matching
  the one directly-CPL-flavored example available (Wikipedia's `while
  Items do`, `if Val > BestVal then`).
- **Numbers and strings.** Decimal integers are confirmed; the
  `#b`/`#o`/`#x` binary/octal/hex prefixes are implemented but are only
  loosely attested (the source text's attribution of this convention to
  CPL specifically, versus a later BCPL-only extension, is ambiguous).
  String escapes use a `*`-prefix (`*n`, `*t`, ...), confirmed directly:
  "Escape sequences in strings such as *n and *t used stars as in CPL."
  Both single- and double-quoted strings are accepted.
- **Comments.** No CPL comment syntax could be confirmed in any source
  read. `//` line comments are supported only as an unconfirmed,
  BCPL-style convenience adopted purely so the example programs below
  could be annotated-free-of-ambiguity; they are not attested for CPL
  itself.
- CPL's structure/record facility ("various schemes ... were discussed
  in design meetings [but] no version was deemed adequate for inclusion
  in the language") was never finalized, so this grammar models only the
  informal vector/subscript convention Richards describes being used
  internally by the CPL compiler itself (e.g. `Mk3(Mult,X,Y)` and
  `T[0]`), not a dedicated record/structure declaration syntax.

Entry rule: `program`.

## Examples

The `examples/` directory contains 10 CPL programs, each built from a
fragment attested in Richards (2011) or Wikipedia: the recursive
factorial function (`let rec Fact(n) = n = 0 -> 1, n * Fact(n-1)`);
value/reference/substitution declarations; a `let ... in` scoped
function definition using section brackets and `result is`;
`if`/`then`/`else`; `test`/`then`/`or`; a `while`/`do` loop (using
section brackets); `until`/`do` and `repeat`/`until`; a `for`/`to`/`by`
loop; the simultaneous-assignment/indirection/address-of example
(`p,v!p:=p+1,p`, `@X`, `LV X`); the informal structure/subscript
convention (`Mk3(Mult,X,Y)`, `T[0]`); and the `where`-qualifier form on
both a declaration's initializer expression and a command.
