# PILOT Grammar

[PILOT](https://en.wikipedia.org/wiki/PILOT) (Programmed Inquiry,
Learning, or Teaching) is a simple high-level language from the 1960s,
developed by psychology professor John Amsden Starkweather as one of
the earliest computer-assisted instruction (CAI) languages. Its
structure is similar to BASIC and FORTRAN, but its commands are single
letters (`T` for "type"/print, `A` for "accept"/input, and so on). It
entered the public domain in 1969 and spawned several dialects (Apple
PILOT, Atari PILOT with turtle graphics, Common PILOT, Super PILOT),
and was later standardized, and then withdrawn, as IEEE Std 1154-1991.

## Source

https://en.wikipedia.org/wiki/PILOT

## Specification

No IEEE/ANSI Common PILOT standard text, and no vendor-specific
reference manual (Apple PILOT, Atari PILOT, etc.), could be located
during research. This grammar is built entirely from the "Language
syntax" section of the Wikipedia article above, which documents the
core command letters and overall line shape with real quoted syntax
examples (though no complete example program). See Notes below for
exactly what that section confirms.

## Notes

**Confirmed directly by the Wikipedia article** (quoted or closely
paraphrased):
- A line has, left to right: an optional label; a command letter; an
  optional `Y` or `N`; an optional parenthesized conditional; a colon
  `:`; and an operand (or several operands separated by commas).
- A label may stand alone on a line: an asterisk followed by an
  identifier, e.g. `*RESTART`.
- String variables are written `$NAME` (e.g. `$FREE`, `$X`); numeric
  variables are written `#Q` (e.g. `#X`, `#AM`). Special variables
  `$MATCH`, `$LEFT`, `$RIGHT` are set by `M:` (not modeled here, since
  no further syntax for referencing them was given).
- Command letters and quoted examples: `T:` type/print (`T:Thank you
  for your support.`, with variable interpolation: `T:Thank you,
  $NAME.`); `A:` accept input (`A:`, `A:$FREE`, `A:$X,$Y,$Z`, `A:#Q`);
  `C:` compute (`C:#AM=(#X+#Y)/2`); `D:` dimension an array ("on some
  implementations" -- no exact syntax given); `E:` end a subroutine, or
  abort the program outside one, with no operand; `J:` jump to a label
  (`J:*RESTART`); `M:` match the input buffer against literals/variables
  (`M:TRUTH,$MEXICO,YOUTH`); `R:` remark/comment; `U:` call a subroutine
  (`U:*INITIALIZE`); a conditional: `T(#X>#Y+#Z):Condition met`.
- `N:` is shorthand for `TN:` (type only if the last match failed); `Y:`
  is shorthand for `TY:` (type only if the last match succeeded).

**Reconstructed / uncertain, since the article doesn't give exact
grammar:**
- The full relational-operator set for conditionals -- only `>` appears
  in the one quoted example. This grammar also accepts `=`, `<>`, `<`,
  `<=`, `>=` as a plausible, undocumented extrapolation.
- `C:`'s expression grammar beyond the one quoted example -- this
  grammar adds `*` (multiplication) and `**` (exponentiation) by analogy
  with BASIC-family languages PILOT otherwise resembles; neither is
  confirmed.
- `D:`'s exact dimension syntax -- modeled here as `D:#NAME(size)`, a
  guess consistent with how `C:`/`A:` reference numeric variables,
  since the article says only that dimensioning exists "on some
  implementations" without showing its syntax.
- Whether `E:` can appear with no colon at all ("used with no operand")
  -- this grammar accepts both `E:` and a bare `E`.

**A genuine lexical ambiguity, and how this grammar resolves it:** a
command letter and its `Y`/`N` suffix are written with no space (e.g.
`TY:`, `JN:`). If every letter were tokenized identically throughout a
line, a lexer would have no way (short of a non-portable per-target
lookahead trick) to tell `TY` the two tokens apart from `TY` a single
two-letter word -- and longest-match would always merge them into one
token, breaking every suffixed command. This grammar resolves it with
two lexer modes instead: before a line's `:` (or before a label's `*`),
only single command letters are recognized (there is no multi-letter
identifier rule to compete with them there); after the `:` (or `*`),
a second mode recognizes identifiers, match words, and variable
references, since command letters have no special meaning in operand
position anyway. The mode returns to the first on each line's newline.

Entry rule: `program`.

## Examples

The `examples/` directory contains 10 PILOT programs, each built from
the constructs confirmed above: `T:` output with variable interpolation;
`A:` accepting a string, a list of strings, and a number; `C:` compute
using the article's own `#AM=(#X+#Y)/2` example; `M:` matching against
literal words and a variable, followed by `TY:`/`TN:`; a label and `J:`
jump forming a loop; `U:` calling a labelled subroutine that ends in
`E:`; the standalone `Y:`/`N:` shorthand forms; the conditional form
`T(#X>#Y+#Z):...`; a `D:` array dimension; and `R:` remarks.
