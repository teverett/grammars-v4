# MAD Grammar

[MAD](https://en.wikipedia.org/wiki/MAD_(programming_language))
(Michigan Algorithm Decoder) is a 1959 ALGOL-family systems/algebraic
programming language and compiler developed at the University of
Michigan for the IBM 704/7090, known for compiling fast and for having
unusually readable, English-like statement keywords (`WHENEVER`,
`TRANSFER TO`, `END OF PROGRAM`). It was influential in early timesharing
and teaching use, and was later followed by MAD/I (an ALGOL-60-based
redesign) and GOM (a free-form 1980s reimplementation for IBM S/370).

## Source

https://en.wikipedia.org/wiki/MAD_(programming_language)

## Specification

No reachable copy of a MAD language reference manual could be found.
Wikipedia cites *A User's Reference Manual for the Michigan Algorithm
Decoder (MAD) for the IBM 7090* (University of Michigan, 1962, 221pp) at
`www.bitsavers.org/pdf/univOfMichigan/mad/L2-UOI-MAD1-2-RX_MADum_62.pdf`,
but that URL returns an HTTP 403 (Forbidden) from bitsavers.org, and no
other online copy, nor a copy of Arden's 1966 "The MAD Manual," could be
retrieved (the University of Michigan's Deep Blue repository returned
either empty content or an HTTP 403 for every candidate link). This
grammar is therefore built from Wikipedia's description of the language
alone, not from a primary-source manual -- see Notes below for exactly
which parts of the grammar are consequently unconfirmed.

## Notes

Because no primary-source manual was reachable, several parts of this
grammar are reconstructed from Wikipedia's description rather than
confirmed against an authoritative reference, and should be treated with
more caution than most other grammars in this repo:

- The `THROUGH label, FOR VALUES OF var = init, step, test` loop form is
  reconstructed from Wikipedia's partial description ("THROUGH
  statement-label, FOR VALUES OF var = expression-list") plus the
  well-known three-part init/step/test idiom attested in secondary
  accounts of MAD; its exact grammar could not be confirmed.
- `FORMAT`, `VECTOR VALUES`, I/O, and declaration statements are modeled
  only as far as Wikipedia's own statement list goes; several
  Wikipedia-listed forms (e.g. `EQUIVALENCE`, `PARAMETER`, `SAVE DATA`,
  tape I/O statements, the `DEFINE BINARY/UNARY OPERATOR` extensibility
  facility, and `INCLUDE` packages such as MATRIX/COMPLEX) are not
  implemented, since there was no way to confirm their exact syntax.
- The original (7090-era) column-sensitive card format -- a label in
  columns 1-10, a comment flagged by `R` in column 11, statement text
  presumably starting at column 12, and a sequence number in columns
  73-80 -- is not modeled column-by-column. Comments instead use a
  `;` line-comment convention (neither the original card-column-eleven
  `R` marker nor GOM's leading-`*` convention could be expressed
  portably: both need a "start of line" check, which in ANTLR4 requires
  a lexer semantic predicate written in one specific target language,
  so it cannot compile across every code-generation target this grammar
  targets -- `;` needs no such check, since it is never otherwise used
  by this grammar). Original MAD's multi-card statement continuation
  mechanism is not implemented; every statement here occupies exactly
  one source line.
- Identifiers are not limited to the original 6-character maximum (this
  grammar instead follows GOM's more permissive, unbounded-length,
  underscore-allowing names), and are case-sensitive here while the real
  language's case-folding behavior is undocumented in the sources found.
- A statement label is syntactically indistinguishable from an ordinary
  identifier (as Wikipedia confirms is also true in real MAD); this
  grammar resolves the resulting ambiguity the same way the language
  itself would have needed line/column position to: here, purely through
  the parser's lookahead, by requiring whatever follows the optional
  leading identifier to be a recognizable statement.
- A floating-point literal with no digits after its decimal point (e.g.
  bare `3.`, shown as valid in Wikipedia's examples) is not supported,
  because MAD's relational/boolean operators are themselves written
  wrapped in dots (`.G.`, `.AND.`, ...) immediately adjacent to operands
  with no required space, and a trailing bare dot on a number would make
  it impossible to tell where the number ends and an adjacent dot-operator
  begins. Write such literals with an explicit trailing zero (`3.0`)
  instead.
- The `DEFINE BINARY/UNARY OPERATOR` and `MODE STRUCTURE` facilities,
  which let a MAD program define new operators and modes in terms of raw
  assembly mnemonics, are a distinctive but assembly-level extensibility
  feature and are out of scope for this grammar.

Entry rule: `program`.

## Examples

The `examples/` directory contains 10 MAD programs: the canonical
`PRINT FORMAT` "Hello, world" example; `INTEGER`/`FLOATING POINT`/
`BOOLEAN`/`DIMENSION` declarations together with a ranged `VECTOR VALUES`
statement; the one-line `WHENEVER ..., stmt` conditional together with
`TRANSFER TO` and a labelled `CONTINUE`; the block `WHENEVER` /
`OR WHENEVER` / `OTHERWISE` / `END OF CONDITIONAL` form; a `THROUGH`
counting loop; `INTERNAL`/`EXTERNAL FUNCTION` definitions (both the
single-expression and multi-statement forms) with `FUNCTION RETURN`;
an `EXECUTE` call to an external function; `READ DATA` and
`PRINT RESULTS`; `PRINT COMMENT`; and `NORMAL MODE IS` together with a
dot-delimited boolean (`.AND.`) and relational (`.G.`) expression.
