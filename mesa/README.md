# Mesa Grammar

[Mesa](https://en.wikipedia.org/wiki/Mesa_(programming_language)) is a
systems programming language developed in the 1970s at Xerox PARC's
Computer Systems Laboratory, used to build the Alto and Xerox Star
systems and the Pilot operating system. It is ALGOL/Pascal-like, with a
strict module system (separate *definitions* and *program* files,
type-checked across module boundaries), and pioneered structured
exception handling (`SIGNAL`, `ERROR`, `CATCH`) and monitors for
concurrency. It directly influenced Wirth's Modula-2 and, through DEC
SRC's Modula-2+/Modula-3, the design of Java; its direct successor at
PARC was Cedar.

## Source

https://softwarepreservation.computerhistory.org/mesa/ (the Computer
History Museum's Mesa history collection)

## Specification

**No copy of the authoritative *Mesa Language Manual*, version 5.0**
(Mitchell, Maybury & Sweet, Xerox PARC CSL-79-3, 1979) **could be read
during research.** Every mirror found -- bitsavers.org (both its
`/pdf/xerox/mesa/` and `/pdf/xerox/parc/techReports/` paths, which
return HTTP 403 to automated fetches on every attempt), a Stuttgart
mirror of the same file (connection refused), and an archive.org item
guess (HTTP 404) -- was unreachable. The manual's existence and location
are confirmed by
[Wikipedia](https://en.wikipedia.org/wiki/Mesa_(programming_language))
and by the Computer History Museum's
[Mesa history collection](https://softwarepreservation.computerhistory.org/mesa/)
(which also links 1976 and 1978 editions of the manual at the same
blocked host), but none of their text could actually be fetched.

**This grammar is consequently built from a combination of the few
facts directly confirmed by Wikipedia, plus general knowledge of Mesa's
well-documented syntax consistent with those confirmed facts and with
its closely related, better-documented descendants (Modula-2, Cedar).
It should be treated as substantially less rigorously sourced than most
other grammars in this repository** -- see Notes below for exactly which
parts are confirmed versus reconstructed.

## Notes

**Confirmed directly by Wikipedia:**
- Every Mesa library module has at least two source files: a
  *definitions* file (the interface, which clients import) and one or
  more *program* files (the implementation); the compiler type-checks
  uses of imported entities across this boundary.
- "Compound commands are indicated by the `BEGIN` and `END` keywords
  rather than braces" -- confirmed explicitly, and directly contradicts
  what might otherwise be assumed from Mesa's C-family descendants.
- All keywords are conventionally written in upper case.
- camelCase was the normal identifier convention, "because of the lack
  of underscore" on the Alto's keyboard/character set.
- The assignment operator is a left-pointing arrow, available as its own
  key on the Alto -- hence this grammar's `ASSIGN` token is the Unicode
  character U+2190; the ASCII substitute `_` (seen used for assignment in
  later Mesa/Cedar listings prepared on conventional terminals, since
  Mesa identifiers themselves never contain underscore) is accepted as an
  alternative spelling.
- Exception-handling primitives named by Wikipedia: `SIGNAL`, `ERROR`,
  `ABORT`, `RETRY`, `CATCH`, `CONTINUE` (Wikipedia mentions "four types
  of exceptions" without naming them, so the exact taxonomy is
  unconfirmed).
- Monitors, with `BROADCAST` as the first implementation, for
  concurrency (not modeled in this grammar at all, since no syntax for
  them could be confirmed).

**Reconstructed from general knowledge of Mesa (not confirmed against a
primary source), consistent with the facts above:**
- `DIRECTORY`/`IMPORTS`/`EXPORTS` module-header clauses; `DEFINITIONS`
  vs. `PROGRAM` module kinds; declarations shaped as `name: TYPE`
  (plain), `name: TYPE _ initExpr` (initialized), `name: PROC [params]
  RETURNS [results] = BEGIN ... END` (procedures); `RECORD [...]`,
  `ARRAY [lo..hi] OF T`, and `POINTER TO T` type constructors.
- Control-flow commands `IF`/`THEN`/`ELSE`, `WHILE`/`DO`/`ENDLOOP`,
  `FOR`/`IN`/`DO`/`ENDLOOP`, `LOOP`/`ENDLOOP`/`EXIT`, and
  `SELECT`/`FROM`/`ENDCASE` (with `=>` separating a case label from its
  statement).
- The catch-phrase form `stmt ! signalName => handlerStmt` for attaching
  an exception handler to a single statement.
- `--` end-of-line comments.
- This grammar deliberately leaves unresolved, by accepting square
  brackets for both: Mesa's procedure-call argument lists and its array
  subscript/record-field-access notation both use `[...]`, so (as with
  several other grammars in this repo built from thin sources) a bare
  syntax tree cannot distinguish a call from a subscript -- that
  distinction needs type information this grammar does not have.
- Not implemented at all, for lack of any confirmed syntax: monitors and
  their `ENTRY`/condition-variable operations, `USING` (generic/typed
  module parameterization), and Cedar-specific extensions (garbage
  collection, dynamic types, ropes).

Entry rule: `program`.

## Examples

The `examples/` directory contains 10 Mesa programs: a minimal `PROGRAM`
module; a `DEFINITIONS` module declaring a record type and a procedure
signature with no body; a `DIRECTORY`/`IMPORTS`/`EXPORTS` module header;
`RECORD`/`ARRAY`/`POINTER` type declarations; a `PROC`/`RETURNS`
definition with `IF`/`THEN`/`ELSE` and `RETURN`; a `FOR`/`IN`/`DO` loop;
a `WHILE`/`DO` loop; a `LOOP`/`EXIT` loop; a `SELECT`/`FROM`/`ELSE`/
`ENDCASE` statement; and a `SIGNAL`/`ERROR` declaration used with a
`CATCH`-style `!`/`=>` catch phrase.
