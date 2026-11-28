# Self Grammar

[Self](https://en.wikipedia.org/wiki/Self_(programming_language)) is a
dynamically-typed, prototype-based, pure object-oriented programming
language, originally developed by David Ungar and Randall B. Smith at
Xerox PARC and Stanford, later continued at Sun Microsystems. It has no
classes: every object is built directly from an existing object (its
"parent") by cloning and adding/overriding slots, and there is no
syntactic distinction between a field read, a field write, and a method
call -- all of them are message sends.

## Source

https://selflanguage.org/

## Specification

https://handbook.selflanguage.org/2024.1/langref.html (the Self Handbook,
chapter 3, "Language Reference" -- the current (2024.1) edition's
authoritative description of Self's syntax and semantics)

See also https://handbook.selflanguage.org/2024.1/syntaxoverview.html for
the handbook's own consolidated EBNF grammar, and
https://en.wikipedia.org/wiki/Self_(programming_language) for a general
overview and history.

## Notes

Self is normally edited live inside a persistent object memory (an
"image"), not written as conventional standalone source files, so the
`examples/` programs here are written the way Self source *is* commonly
seen in the handbook and in `.self` snippets: object-literal expressions
and message sends, evaluated at the top level.

Deliberate simplifications, made because Self's own grammar is
intentionally ambiguous in places (the handbook says precedence and
associativity rules, not the grammar itself, resolve these cases) or
because some lexical detail could not be confirmed from the sources
fetched during research:

- **Implicit-receiver messages are not supported.** Self allows a binary
  or keyword message with no receiver at all (`+ 3`, `max: 5`), implying
  `self`. Supporting this as a genuine grammar alternative, alongside
  ordinary receiver-first binary/keyword expressions, would require
  restructuring the expression hierarchy in a way that risks new
  ambiguity; this grammar requires an explicit receiver (`self + 3`,
  `self max: 5`) instead. All examples here write the receiver out.
- **Homogeneous-operator-only binary chaining is not enforced.** The
  handbook's semantic rule that `3 + 4 * 7` is illegal (mixed binary
  operators have no defined associativity) is a well-formedness rule
  layered on top of the grammar, not a syntax rule; this grammar parses
  any left-to-right chain of binary messages, leaving that restriction
  unchecked.
- **Resend syntax (`resend.msg` / `ParentName.msg`) requires no
  whitespace around the `.. ` in real Self**, which a context-free lexer
  cannot distinguish from an ordinary statement-separator `.` between
  two unrelated statements (e.g. `resend . display`). This grammar always
  prefers the resend-expression reading, which matches every realistic
  resend example but means a stray `name. identifier` sequence written at
  statement level with a deliberate space will also be parsed as a resend
  send rather than two statements.
- **Symbol and character literals, and collection literals** (`#()`-style
  vectors/arrays/dictionaries) have no documented grammar production in
  the Language Reference or its syntax-overview appendix, so they are not
  implemented.
- The apostrophe (`'`) is listed among the handbook's legal operator
  characters, but is excluded from this grammar's operator-character set,
  since treating it as such would make an operator token ambiguous with
  the start of a string literal.
- The on-disk Transporter/category file format (handbook section 6.4) was
  not reachable during research and so is not modeled; only the in-image
  object-literal/expression syntax is covered.

Entry rule: `program`.

## Examples

The `examples/` directory contains 10 Self programs covering: a minimal
unary-message statement; a data-slot object with a `parent*` slot; unary
and binary method slots (including a `clone`-based immutable-update
pattern); a keyword method slot combined with `ifTrue:False:`-style
control flow; undirected and directed `resend`; numeric literal forms
(radix, fixed-point, and exponent) and a string literal with escapes; a
non-local return from inside a block via `^`; a block with declared
arguments (`[ | :each | ... ]`); an assignable (dynamically-reparentable)
parent slot; and the comment-annotation (`{} = '...'`) and categorized
slot-group (`{ 'Category: ...' ... }`) forms.
