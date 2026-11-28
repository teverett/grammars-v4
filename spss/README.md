# SPSS Grammar

[SPSS](https://en.wikipedia.org/wiki/SPSS) (originally "Statistical
Package for the Social Sciences", now branded IBM SPSS Statistics) is
statistical software first released in 1968. Beyond its menu-driven
interface, it is driven by a proprietary batch/command language usually
called "SPSS syntax" or "command syntax" -- commands like `DATA LIST`,
`COMPUTE`, `DO IF`, and `FREQUENCIES`, each ending in a period, typically
saved in `.sps` files. The GUI can paste the syntax it generates into a
syntax file for editing, review, or unattended re-use.

## Source

https://en.wikipedia.org/wiki/SPSS

## Specification

IBM's own authoritative reference, the *IBM SPSS Statistics Command
Syntax Reference*, could not be read during research: its IBM
Documentation pages
(`https://www.ibm.com/docs/en/spss-statistics/latest?topic=syntax-command-rules`)
render their content entirely via JavaScript, so an automated fetch
returns only a bare page title with no syntax content. This grammar is
instead built primarily from the lexical rules documented in
[GNU PSPP's manual, section 6.1 "Tokens"](https://www.gnu.org/software/pspp/manual/html_node/Tokens.html)
-- PSPP is a free-software program explicitly designed to read and write
SPSS-compatible command syntax, and its manual documents that syntax in
detail -- together with general, widely-documented knowledge of SPSS's
individual commands (`DATA LIST`, `COMPUTE`, `DO IF`, `LOOP`, `RECODE`,
and so on) consistent with those confirmed lexical rules. See Notes
below for exactly which parts are confirmed versus reconstructed.

## Notes

**Confirmed directly by the PSPP manual's Tokens page** (quoted or
closely paraphrased):
- The period (`.`) is a punctuator only when it is the last non-space
  character on a line; otherwise it may be part of another token (e.g.
  a decimal point). A number like `8945.` is two tokens, `8945` and `.`,
  when the period is last on its line.
- Identifiers start with a letter, `#`, or `@`, and continue with
  letters, digits, or `. _ $ # @`; they are case-insensitive, and only
  the first 64 bytes are significant. Reserved identifiers: `ALL AND BY
  EQ GE GT LE LT NE NOT OR TO WITH`.
- Keywords may be abbreviated to their first three characters when
  unambiguous (e.g. `FRE`/`FREQ`/`FREQUENCIES` are equivalent).
- Numbers are decimal, with an optional decimal point and optional
  scientific notation (`-5`, `3.14159265359`, `1e100`, `-.707`).
- Strings are single- or double-quoted, with the quote character
  doubled to escape it, and can be concatenated with `+`; optional
  `x`/`X` (hex) or `u`/`U` (Unicode code point) prefixes are also
  recognized.
- Punctuators/operators: `, / = ( ) + - * / ** < <= <> > >= ~= & | .`

**Reconstructed from general knowledge of SPSS syntax** (not confirmed
against either IBM's or PSPP's command-level documentation, since the
PSPP manual's own `Commands.html` and `BNF.html` pages -- which would
have documented command/continuation/comment rules formally -- could not
be fetched: the GNU web server rate-limited every attempt to read them
during this research session):
- The overall `COMMAND name /SUBCOMMAND keyword=value ...` shape, and
  the specific commands given dedicated rules here: `BEGIN DATA`/
  `END DATA`, `DATA LIST`, `VARIABLE LABELS`, `VALUE LABELS`,
  `MISSING VALUES`, `GET FILE`, `SAVE OUTFILE`, `COMPUTE`, `IF`,
  `DO IF`/`ELSE IF`/`ELSE`/`END IF`, `LOOP`/`END LOOP`, `RECODE`,
  `SELECT IF`, and `EXECUTE`.
- `*` at the start of a command, and the `COMMENT` command, both running
  to the next terminating period, as SPSS's two comment forms.
- Every other command (`FREQUENCIES`, `DESCRIPTIVES`, `REGRESSION`,
  `CROSSTABS`, and the hundreds of others in SPSS's full vocabulary) is
  handled only by a generic fallback rule -- a single leading identifier
  (the command name) followed by arbitrary tokens up to the terminating
  period -- which checks the command is present and terminated but does
  not validate its internal (sub)structure. Only single-word command
  names are recognized this way; a multi-word command name not given its
  own dedicated rule above would not parse.

**Deliberate simplifications:**
- Like numbers (see the Tokens page quote above), an identifier here
  never ends in a bare trailing `.` -- an internal dot is only accepted
  when followed by at least one more identifier character. Otherwise a
  variable name directly followed by the command-terminator period with
  no space (e.g. `i.`, extremely common at the end of a line) would
  always be swallowed whole into one identifier token, leaving the
  parser with no separate terminator to see. This mirrors the same
  trailing-dot ambiguity handled the same way in this repo's `dylan` and
  `clean` grammars.
- Keyword abbreviation (confirmed above as a real SPSS/PSPP feature) is
  not implemented -- doing so would require normalizing abbreviated
  keywords dynamically, which a static lexer cannot do; every keyword
  must be spelled out in full in examples here.
- Case-insensitivity is not enforced; all keywords are written upper
  case, matching the convention used throughout the PSPP manual's own
  examples and IBM's own documentation style.

Entry rule: `program`.

## Examples

The `examples/` directory contains 10 SPSS syntax files: `DATA LIST
FREE` with a `BEGIN DATA`/`END DATA` inline data block; `VARIABLE
LABELS` and `VALUE LABELS`; `MISSING VALUES`; `GET FILE` and `SAVE
OUTFILE`; `COMPUTE` and a single-statement `IF`; a `DO IF`/`ELSE IF`/
`ELSE`/`END IF` block; a `LOOP`/`END LOOP`; `RECODE ... INTO` together
with `SELECT IF`; the generic-command fallback exercised against
`FREQUENCIES`, `DESCRIPTIVES`, and `CROSSTABS`; and both comment forms
(`*` and `COMMENT`).
