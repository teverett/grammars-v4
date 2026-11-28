# GPSS Grammar

[GPSS](https://en.wikipedia.org/wiki/GPSS) (General Purpose Simulation
System) is a block-structured, transaction-flow discrete-event simulation
language created by Geoffrey Gordon at IBM in 1961. A GPSS model is written
as a sequence of block statements (e.g. `GENERATE`, `QUEUE`, `SEIZE`,
`ADVANCE`, `RELEASE`, `TERMINATE`); "transactions" flow through the
resulting block diagram, modeling entities (customers, parts, messages, ...)
moving through a simulated system over time. GPSS is still maintained and
sold today as "GPSS World" by Minuteman Software.

## Source

https://en.wikipedia.org/wiki/GPSS

## Specification

No live, authoritative GPSS reference could be reached while writing this
grammar. Minuteman Software's site (`minutemansoftware.com`), which hosts
the modern GPSS World Reference and Tutorial manuals, refused every
connection attempt (not a 404 -- the whole host was unreachable), and a
university mirror of the manual linked from the Wikipedia article
(`athena.ecs.csus.edu/~simulation/gpss/`) returned HTTP 403 Forbidden. The
Wikipedia article above -- which itself documents the core block types with
examples -- was the best available source and was used instead:

https://en.wikipedia.org/wiki/GPSS

## Notes

Because the authoritative GPSS World manuals could not be reached, this
grammar is built from secondary material (the Wikipedia article and general
background knowledge of classic GPSS) rather than a verified transcription
of the official reference, and makes the following deliberate
simplifications:

- One statement per line: an optional label (a bare identifier) followed
  by a block/command keyword and a comma-separated operand list, e.g.
  `AGAIN ADVANCE 2,1`. This grammar supports a representative subset of
  block types -- `SIMULATE`, `GENERATE`, `TERMINATE`, `QUEUE`, `DEPART`,
  `SEIZE`, `RELEASE`, `PREEMPT`, `RETURN`, `ADVANCE`, `ENTER`, `LEAVE`,
  `ASSIGN`, `TRANSFER`, `TEST`, `GATE`, `PRIORITY`, `LOOP`, `MARK`,
  `TABULATE`, `SAVEVALUE`, `SPLIT`, `ASSEMBLE`, `START`, `END`, `STORAGE`,
  `FUNCTION`, `VARIABLE`, `TABLE` -- rather than GPSS World's full command
  set.
- Comments use `;` to end of line, matching GPSS World's own convention
  for trailing/line comments. This grammar does not model the original,
  fixed-column card-image convention (a line beginning with `*` in column 1
  is a full-statement comment), since that would require per-target lexer
  action code to detect "start of line", which this repo's grammars avoid
  because `desc.xml` generates drivers for many ANTLR targets (Java, C#,
  Go, Python, JavaScript, ...) that don't share a portable way to express
  it, and it would otherwise collide with `*` as the multiplication
  operator.
- Operands are always comma-separated, including condition-code operands
  on blocks like `TEST` and `GATE` (e.g. `TEST GE,P1,2,SKIP`); this grammar
  does not attempt to model any space-separated mnemonic-plus-operand
  shorthand that real GPSS dialects may allow.
- Standard Numerical Attributes (SNAs) such as `P1`, `X1`, `Q1`, `FN1`,
  `V1` are modeled generically as identifiers, optionally followed by
  `$NAME` for name-indexed references (`X$COUNT`, `FN$SERVTIME`), rather
  than enumerating every SNA family and its exact operand-indexing rules.
- Expressions support `+ - * /` and parenthesization; the `@` operator is
  accepted as an additional binary operator (GPSS's modulo-like operator)
  but its exact precedence relative to `*`/`/` was not verified against a
  primary source.

Entry rule: `program`.

## Examples

The `examples/` directory contains 10 GPSS models exercising: a classic
single-server queueing model (`SIMULATE`/`GENERATE`/`QUEUE`/`SEIZE`/
`DEPART`/`ADVANCE`/`RELEASE`/`TERMINATE`/`START`/`END`), a labeled block
used as a `LOOP` target, unconditional and statistical `TRANSFER`, a
multi-capacity `STORAGE` facility with `ENTER`/`LEAVE`, a `FUNCTION`
definition referenced from `ADVANCE`, a `VARIABLE` expression combining
two savevalues, `ASSIGN` plus a `TEST` conditional block, a `GATE` block,
`SAVEVALUE` with an `X$`-indexed reference, and a `TABLE`/`TABULATE` pair
collecting statistics.
