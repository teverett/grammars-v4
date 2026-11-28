# IPL Grammar

[IPL](https://en.wikipedia.org/wiki/Information_Processing_Language)
(Information Processing Language) is one of the earliest list-processing
languages, designed around 1956-1958 by Allen Newell, Cliff Shaw, and
Herbert Simon at RAND Corporation and Carnegie Institute of Technology.
It was used to implement the Logic Theorist and (later) the General
Problem Solver, two of the first AI programs, and predates Lisp. Its
native form (IPL-V, the only publicly released version) represents a
program as a sequence of numbered "cells," each holding an operation
code, an indirection selector, a symbol, and an implicit link to the
next cell -- closer to assembly language or raw memory layout than to
any conventional program text.

## Source

https://en.wikipedia.org/wiki/Information_Processing_Language

## Specification

No reachable copy of an IPL-V language reference manual could be found.
The 1964 *Information Processing Language-V, Second Edition* manual by
Newell et al. is referenced by Wikipedia and archived (as a scanned,
OCRed PDF) in the
[jeffshrager/IPL-V](https://github.com/jeffshrager/IPL-V) repository,
but that PDF is too large to fetch directly, and bitsavers.org's own
copy of an IPL manual returns an HTTP 403. The IPL-V cheat sheet in the
same repository also could not be read as text.

Lacking the manual, this grammar instead targets a different, but
concretely available and verified, textual representation of IPL-V
programs: the **`.liplv` transcription format** used by that same
repository to represent IPL-V cell listings as Lisp-style S-expressions
(for example,
[`LTFixed.liplv`](https://github.com/jeffshrager/IPL-V/blob/master/LTFixed.liplv),
a transcription of the Logic Theorist from Stefferud's 1963 RAND report).
This is **not** IPL-V's original 1958 punched-card syntax -- it is a
later, spreadsheet-like re-encoding of the same cell data, one row per
cell, created for that repository's own Common Lisp interpreter -- but
it is the only form of IPL source actually readable in the sources
available during research, so this grammar models exactly that.

## Notes

- A `.liplv` file is a sequence of parenthesized, 9-field tuples, one per
  IPL cell, each field a double-quoted string (empty fields are `""`).
  The first row is conventionally a header of `:keyword`-style field
  names: `(:comments :type :name :sign :pq :symb :link :comments.1 :id)`.
  A data row looks like
  `("" "2" "A" "" "" "" "10" "" "0000 000")`.
- The fields, inferred from the header row and the sampled cell rows
  (not from a manual, so treat these meanings as informed inference, not
  confirmed fact): a free-text comment; a cell-type code (seen values
  include `"9"` title, `"2"` data/symbol cell, `"5"` program header,
  `"1"` routine end, and empty for an ordinary instruction cell); the
  cell's symbolic name; a sign field (always empty in the material
  sampled); a two-digit `P`+`Q` operation/indirection code (e.g. `"60"`,
  `"70"`); the cell's `SYMB` operand (e.g. `W0`, `9-4`, `J75`, `M43`); the
  `LINK` to the next cell; a secondary annotation comment; and a
  routine/line identifier (e.g. `M001R020`).
- This grammar does **not** attempt to decode or validate the meaning of
  the `pq` operation codes, nor the symbol-naming conventions (`W`
  working cells, `H` special/reserved cells, `9-`-prefixed list-local
  symbols, and so on) -- no numeric opcode table could be confirmed from
  any reachable source, so the grammar treats every field as an opaque
  string and only checks the surrounding S-expression structure.
- Comments are supported as `.liplv`-style Lisp comment lines beginning
  with `;`, `;;`, or `;;;` (all three forms are seen in the source
  repository's own files), running to end of line.
- The native 1958/1964 IPL-V card/cell format -- which Wikipedia
  describes only structurally (P/Q/SYMB/LINK fields, ~150 primitive
  operation codes, regional/local/internal symbol naming) and never
  shows as literal source text -- is out of scope for this grammar,
  since no example of it in that original form could be found to
  validate a grammar against.

Entry rule: `program`.

## Examples

The `examples/` directory contains 10 `.liplv` files, each adapted from
real rows transcribed in `LTFixed.liplv` (the Logic Theorist listing):
the bare header row; a `PROGRAM HEADER` cell; a routine-start cell paired
with its routine-end cell; data/symbol cells; plain instruction cells
with a `pq` code and `symb` operand; a bare subroutine-call cell with no
`pq`; a conditional-branch-shaped cell (`pq` `"70"`, commented "IF NO
GOOD, QUIT"); `;`/`;;`/`;;;`-style comment lines; a spread of the
different symbol-name prefixes seen in the source (`W`, `K`, `N`, `Q`,
`9-`, `P`); and a small multi-cell routine combining several of the
above into one listing.
