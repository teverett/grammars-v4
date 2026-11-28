# CORAL 66 Grammar

[CORAL 66](https://en.wikipedia.org/wiki/CORAL_66) (Computer On-line Real
time Applications Language) is a British real-time systems programming
language from the 1960s, derived from ALGOL 60, designed at the Royal
Radar Establishment, Malvern, under the Inter-Establishment Committee
for Computer Applications (IECCA), and officially defined by the UK
Ministry of Defence in 1970 (standardized as BS 5905). It was used
extensively in UK military and real-time control systems.

## Source

https://en.wikipedia.org/wiki/CORAL_66

## Specification

https://archive.org/details/official-definition-of-coral-66 (HMSO,
*Official Definition of CORAL 66*, 1970, 2nd impression 1973) -- a
scanned copy with an OCR text layer, readable at
https://archive.org/stream/official-definition-of-coral-66/Official%20Definition%20of%20Coral%2066_djvu.txt.
This grammar is built directly from that OCR text (through section
11.3; Appendices 2 and 3 were not read), which is the authoritative
primary source for the language -- but the OCR itself is imperfect, and
several lexical glyphs came through illegibly. See Notes below for
exactly which parts are confirmed verbatim versus reconstructed.

## Notes

**Confirmed directly from the Official Definition's text** (several
assumptions going into this grammar turned out to be wrong, and are
corrected here):
- There is **no** `PROGRAM ... END`. A program is a name, optional
  *communicators* (`COMMON (...)`), and one or more named *segments*,
  each a `BEGIN ... END` block (`name: BEGIN ... END`).
- Numeric types are `FLOATING`, `FIXED (totalbits, fracbits)`, and
  `INTEGER` -- **not** `REAL`, `BOOLEAN`, or `LONG INTEGER` (there are no
  Boolean variables at all; conditions are only formed from comparisons
  combined with `AND`/`OR`).
- There is **no** `CYCLE`, `REPEAT`, standalone `WHILE` statement,
  `CASE`, or `EXIT`. Iteration is only the `FOR` statement, whose list
  elements can be a plain expression, `expr WHILE condition`, or `expr
  STEP expr UNTIL expr` (confirmed examples: `FOR i <- 1, 2, 4, 7, 15 DO
  ...`; `FOR i <- i+1 WHILE x < y DO ...`).
- Assignment and array/variable presetting both use `<-` (confirmed by
  many examples throughout the definition, e.g. `i <- 0;`, `INTEGER a,
  b, c <- 1, 2, 3;`).
- `COMMENT` comments are confirmed verbatim: "the word COMMENT followed
  by text and terminated by a semi-colon." A second, bracketed `(...)`
  comment form (used directly after a `;`) is described but **not**
  implemented here, since distinguishing it from an ordinary
  parenthesized expression would need bracket-depth tracking the lexer
  cannot portably do; only the `COMMENT ... ;` form is supported.
- Declarations: scalars (`FIXED (13,5) x, y;`), one- and two-dimensional
  arrays (`INTEGER ARRAY p, q, r[1:3], t, u[1:2, 1:3];`), `SWITCH s <-
  a, b, c;`, `LABEL` specifications, `OVERLAY base WITH ...`, and
  `TABLE` declarations are all confirmed, with real quoted examples for
  each except `TABLE` (reconstructed below).
- Procedures: a typed procedure is `Answerspec PROCEDURE Heading ;
  Statement` (e.g. `INTEGER PROCEDURE p; ANSWER i;`); a recursive one
  drops the `PROCEDURE` keyword: `Answerspec RECURSIVE Heading ;
  Statement`. Parameters use `VALUE`/`LOCATION` specifiers
  (`f (VALUE INTEGER n; LOCATION INTEGER m)`). `ANSWER expression` both
  returns a value and exits the procedure.
- Part-word access: `BITS [totalbits, bitposition] primary`, both as an
  assignment target and as a value.
- Word-logical operators `DIFFER`, `UNION`, `MASK` exist, listed loosest
  to tightest (treated here at the same, tightest precedence level,
  immediately above the primary).
- The section 8.4 worked example (reproduced as `examples/spec_example_8_4.c66`)
  is quoted directly from the OCR text and is the only complete piece of
  CORAL 66 source material found anywhere during research.

**Reconstructed or left uncertain, because the OCR of this one scanned
copy was illegible or incomplete at these specific points:**
- **Comparator symbols.** The grammar line literally OCR's as
  `Comparator = <` with the rest of the line lost; the surrounding prose
  confirms there are six relations (less than, less than-or-equal, equal,
  greater-or-equal, greater, not-equal) but gives no symbols for five of
  them. This grammar uses the ordinary ALGOL-family glyphs `<`, `<=`,
  `=`, `>=`, `>`, `<>` -- `<` alone is directly confirmed; the rest are
  an unverified best guess.
- **String quote character.** The definition confirms strings are
  "enclosed in quotation marks (string quotes)" but the quote glyph
  itself did not survive the OCR. This grammar uses a single quote `'`
  as a documented ASCII substitute.
- **Real-number exponent notation.** The grammar shows `Digitlist
  <illegible> 10 Signedinteger` -- some "times ten" operator glyph
  between the mantissa and the exponent did not survive the OCR at all.
  Rather than invent an unconfirmed ASCII spelling for it, this grammar
  does **not** support scientific notation for `REAL_LIT` -- only plain
  `digits.digits` decimals.
- **Macro-definition brackets.** `DEFINE name «body»` -- the opening `«`
  is directly attested in one verbatim OCR'd example (`DEFINE shift6 «
  CODE BEGIN 123,45,6 END *;`); the closing bracket OCR'd as a stray
  `*`, which is almost certainly a scan artifact of `»`, its natural
  pairing -- this grammar uses `»` for the close, but that half is a
  reconstruction, not a direct read.
- `TABLE`'s element-declaration syntax (`elementDecl`) is modeled from a
  single partial example quoted secondhand (`rain UNSIGNED (4,2) 2,0;`)
  rather than from the formal grammar text itself, and should be treated
  as the least-confirmed declaration form in this grammar.
- `ABSOLUTE`'s addressing syntax (mentioned as using a `/` between an
  identifier and an integer) is not implemented, since the relevant OCR
  text was reported as "slash OCR-uncertain" and no confirmed example
  was found.

**Not modeled, for lack of any confirmed syntax:** the `DEFINE` macro's
parameterised-call-site form (`name(Macrostringlist)`) beyond the bare
`DEFINE name (params) «body»` declaration shape; `CODE` statement bodies
are treated as an opaque, implementation-defined token sequence (as the
definition itself describes them); and the `COMMON (...)` communicator
block is modeled only as a list of ordinary declarations, since its
full, more specialized contents were not read in detail.

Entry rule: `program`.

## Examples

The `examples/` directory contains 11 CORAL 66 programs: the Official
Definition's own section-8.4 worked example verbatim (nested blocks,
re-declared `i`, and a typed procedure answering the outer `i`); scalar
and array declarations with presetting; the three `FOR` loop forms;
`IF`/`THEN`/`ELSE` with `AND`/`OR` conditions; `LABEL`/`SWITCH`/`GOTO`;
a recursive factorial procedure; `OCTAL`/`LITERAL` integer forms;
`COMMENT` statements; a `DEFINE`/macro-invocation example; `BITS`
part-word access as both an assignment target and a value; and nested
blocks including a block used as the body of an `IF`.
