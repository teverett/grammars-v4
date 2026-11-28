# RPG III Grammar

[RPG III](https://en.wikipedia.org/wiki/RPG_III) is IBM's third generation
of the RPG ("Report Program Generator") business programming language,
first announced with the IBM System/38 in 1978 and later carried forward
to the AS/400 (iSeries). Unlike most languages, RPG III programs are not
written as free-form statements -- they are built from fixed-column,
card-image "specification" lines, each identified by a single-letter form
type in a specific source column: `H` (control/header), `F` (file
description), `I` (input), `C` (calculation), and `O` (output).

## Source

https://en.wikipedia.org/wiki/IBM_RPG

## Specification

https://en.wikipedia.org/wiki/RPG_III

A current, free, authoritative IBM reference for RPG III specifically
could not be confirmed: `ibm.com/docs/en/i` resolves but renders its
content client-side (no static manual text to link to directly), and
`ibm.com/support/pages/rpg` returns HTTP 404. The two Wikipedia articles
above were used instead and were reachable and on-topic.

## Notes

Classic RPG III source is a fixed-column, "card-image" format: each
specification line's fields are identified purely by which character
columns they occupy, not by any delimiter. Faithfully modeling that would
require a lexer that tracks column position to decide what a given run of
characters means -- which needs target-specific action code, and this
repo's grammars avoid that because `desc.xml` generates drivers for many
ANTLR targets (Java, C#, Go, Python, JavaScript, ...) that don't share a
portable way to express it. This grammar instead models the same
specification lines and fields, in the same left-to-right order, delimited
by whitespace and a small amount of explicit punctuation instead of fixed
source columns:

- One statement per line, starting with a spec-type letter: `H`, `F`,
  `I`, `C`, or `O`.
- `H` (control) and `F` (file description) specs are modeled as the
  spec letter followed by a flat list of words (e.g.
  `F CUSTMAST IF E DISK`).
- `I` (input) specs are either a bare record-identifying line
  (`I CUSTREC`) or a single field definition
  (`I BALANCE 21-30,2` -- field name, from-to column range, optional
  decimal positions); unlike real RPG III, this grammar does not support
  multiple field definitions sharing one physical line.
- `C` (calculation) specs follow factor1/op-code/factor2/result order
  (e.g. `C TOTAL IFGT 1000`, `C ADD AMOUNT TOTAL`) using a representative
  subset of RPG III's operation codes (arithmetic, `MOVE`/`MOVEL`,
  `IFxx`/`ELSE`/`ENDIF`, `DO`/`ENDDO`, `GOTO`/`TAG`, file I/O, `CALL`/
  `PARM`, `EXSR`/`BEGSR`/`ENDSR`, `SETON`/`SETOF`, `RETRN`, `END`).
  Controlling and resulting indicators, which real RPG III places in
  fixed columns, are instead written in explicit parentheses (e.g.
  `C (10) MOVE 'OVER' MSG`, `C COUNT COMP LIMIT (10,20)`); this is a
  deliberate departure from authentic column-based indicator placement,
  needed to keep the grammar unambiguous without column tracking.
- `O` (output) specs are the spec letter, a file/record name, and a flat
  list of field names, constants, and numbers; edit-word formatting and
  the exact semantics of `O` spec continuation lines are not modeled.
- Comments are lines starting with `*`.
- Field length and decimal-position sub-fields that real RPG III derives
  from fixed column boundaries are not otherwise tracked beyond the
  explicit `from-to[,decimals]` form used in `I` specs.

Entry rule: `program`.

## Examples

The `examples/` directory contains 10 RPG III programs exercising: a
basic `EXCPT`/output-line greeting, a disk file with input field
definitions, arithmetic calc-spec operations, `IFxx`/`ELSE`/`ENDIF`,
`DO`/`ENDDO`, parenthesized controlling/resulting indicator groups,
`CHAIN`/`READ`/`WRITE`/`UPDATE`/`DELETE` file access, `CALL`/`PARM`,
`EXSR`/`BEGSR`/`ENDSR` subroutines, `GOTO`/`TAG`/`RETRN`/`END`, and a
multi-line printer output report.
