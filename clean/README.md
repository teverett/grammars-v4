# Clean Grammar

[Clean](https://en.wikipedia.org/wiki/Clean_(programming_language)) is a
lazy, pure functional programming language developed at Radboud
University Nijmegen, broadly similar to Haskell but with its own
distinctive syntax and a uniqueness-typing system (rather than monads)
for handling I/O and other side-effecting state. Source files use the
`.icl` (implementation) and `.dcl` (definition) extensions.

## Source

https://clean.cs.ru.nl/ (the Clean Wiki, also mirrored at
https://wiki.clean.cs.ru.nl/Clean)

## Specification

http://clean.cs.ru.nl/download/html_report/CleanRep.2.2_1.htm (the Clean
2.2 Language Report, the language's reference manual; the project's
current stable release is 5.0, but this is the most recent version of
the report that could be located and fetched in full, and no evidence of
a later-numbered report superseding it was found)

See also https://en.wikipedia.org/wiki/Clean_(programming_language) for
a general overview and side-by-side Haskell comparison.

## Notes

Clean's default surface syntax is layout-sensitive (an offside/indentation
rule much like Haskell's), which an ANTLR4 grammar's context-free parser
rules cannot express directly. The Language Report itself documents an
alternative, fully explicit surface syntax for exactly this reason
(section 2.3.3): writing a `;` immediately after a module's name turns
indentation-based layout off for the rest of that module, after which
every definition must end with an explicit `;` and every block (`where`,
`with`, `let`, `of`, class/instance bodies, etc.) must use explicit `{ }`
grouping instead of being implied by indentation. **This grammar
implements that explicit, layout-off form** -- every example file in
`examples/` starts with `module name;` and uses explicit `;`/`{ }`
throughout -- rather than the indentation-sensitive form most real-world
Clean code is written in.

Other deliberate simplifications/omissions, and known uncertainties:

- Nested block comments (`/* /* ... */ ... */`, which the Report says
  Clean supports) are matched with a simple, non-nesting `/* ... */`
  lexer rule, since ANTLR lexer rules can't express arbitrary nesting
  depth directly.
- Several tokens are genuinely context-dependent in Clean (`*`/`.` as
  uniqueness-type attributes vs. multiplication/record-selection; `!` as
  strictness annotation vs. unique-array selection; `#` as the unboxed-type
  marker vs. the `#`/`#!` "let-before" binding form). This grammar
  resolves each case through separate parser rules for type-level vs.
  expression-level contexts rather than through lexer modes.
- `class`/`instance` definitions and `generic` definitions are supported
  only in a minimal form (a `where`-block of plain type signatures /
  function equations). Chapter 5 of the Language Report, which covers
  these and record types in full, could not be fetched during research
  (the HTML report pages for that chapter were not reachable), so this
  part of the grammar is pattern-inferred from the BNF appendices and
  from Wikipedia's examples rather than confirmed against that chapter's
  prose -- treat it as the least-verified part of this grammar.
- `Start`, the program's entry point, is capitalized by convention even
  though ordinary function names are otherwise lowercase; it is given its
  own lexer token (ahead of the general uppercase-identifier rule) rather
  than being treated as a constructor-like name.
- Uniqueness-type inequality constraints (`u <= v` between uniqueness
  variables) and rank-2 explicit quantifiers (`A.a: ...`, `E.a: ...`) are
  not implemented, since the fetched grammar text for these was partial
  or garbled and could not be confirmed.

Entry rule: `program`.

## Examples

The `examples/` directory contains 10 Clean programs (all in the
layout-off style described above), covering: a minimal `Start` program;
recursive function definitions; multi-equation functions with guards;
algebraic data types, records (including record update and record-field
selection), and a type synonym; list comprehensions (including parallel
`&` generators and the `..` range forms); `case`/`let`/`where` local
definitions; lambda expressions and higher-order functions; the
uniqueness-typed `*World` I/O convention; strict/array types and array
update/selection/comprehension syntax; and operator definitions with
explicit `infixl`/`infixr` fixity declarations together with a record
type using strict (`!`) fields.
