# Ruby Grammar

[Ruby](https://www.ruby-lang.org/en/) is a dynamic, object-oriented
scripting language created by Yukihiro "Matz" Matsumoto, first released
in 1995. It blends ideas from Perl, Smalltalk, Eiffel, Ada, and Lisp,
emphasizing programmer happiness and readability; "everything is an
object" and nearly every control-flow construct (`if`, `case`, `begin`,
method/class definitions) is itself an expression that returns a value.

## Source

https://www.ruby-lang.org/en/

## Specification

https://docs.ruby-lang.org/en/3.3/syntax/literals_rdoc.html (and its
sibling pages under `docs.ruby-lang.org/en/3.3/syntax/`:
[control_expressions](https://docs.ruby-lang.org/en/3.3/syntax/control_expressions_rdoc.html),
[methods](https://docs.ruby-lang.org/en/3.3/syntax/methods_rdoc.html),
[calling_methods](https://docs.ruby-lang.org/en/3.3/syntax/calling_methods_rdoc.html),
[exceptions](https://docs.ruby-lang.org/en/3.3/syntax/exceptions_rdoc.html),
and [precedence](https://docs.ruby-lang.org/en/3.3/syntax/precedence_rdoc.html))
-- the official Ruby core documentation's syntax reference, which this
grammar was built and checked against directly.

## Notes

Ruby's full grammar is large, and several of its more advanced or
rarely-used forms are deliberately out of scope here. **Covered:**
literals (integers in all bases, floats, single- and double-quoted
strings with `#{...}` interpolation, symbols, regular expressions,
arrays, hashes with both `=>` and `key:` syntax, ranges, `nil`/`true`/
`false`); local/instance (`@x`)/class (`@@x`)/global (`$x`)/constant
variables; `def` (including endless methods `def area = ...`, operator
method definitions like `def +`/`def ==`, and the full parameter set --
required, optional, splat, double-splat, keyword, block, and
destructuring parameters); `class`/`module`; `if`/`unless`/`case`/
`when`/`while`/`until`/`for`, their statement modifiers (`expr if
cond`), and the `do`/`while` form; `begin`/`rescue`/`else`/`ensure`/
`retry`, including the implicit form (a `def` or block body with
`rescue` directly, no `begin` needed); method calls with and without
parentheses, receivers (`.`, `&.` safe navigation, `::`), and both
`{ }` and `do...end` blocks; `lambda`/`->`; the full documented operator
set and its precedence table (including `&&`/`||`/`and`/`or`/`not` at
their differing precedence levels, and the ternary and range
operators); and multiple assignment (`a, b = b, a`).

**Not covered, for scope reasons** (none of these are exotic or
undocumented -- they are simply a large amount of additional surface
area beyond a first grammar's reasonable scope):
- Heredocs (`<<~ID ... ID`) in any of their forms.
- Percent literals other than the plain `%q`/`%Q`-style string, which
  isn't modeled either -- none of `%w[...]`, `%i[...]`, `%r{...}`
  (percent-delimited regex), or `%x(...)` are implemented. (A plain
  `/regex/` literal *is* supported, but its content is treated as
  opaque text, not a nested sub-grammar.)
- `case/in` pattern matching (as opposed to `case/when`).
- The flip-flop operator (`if value == 2..value == 8`).
- `BEGIN`/`END` blocks, `__END__`, numbered block parameters (`_1`),
  and the `it` implicit block parameter.
- `throw`/`catch` are ordinary `Kernel` method calls as far as syntax
  is concerned, so they parse as ordinary method calls already --
  nothing dedicated was added for them.
- Character literals (`?a`) and the rarer escape forms inside them.

**A note on string interpolation's implementation:** `#{...}` content
is tokenized by pushing the lexer into a mode that mirrors the normal
code-level tokens, so that an interpolated expression is tokenized
(and nests through further braces, e.g. a hash literal inside an
interpolation) the same way ordinary code is, using only the portable
`pushMode`/`popMode` lexer actions -- no custom counters or
target-specific lexer APIs, consistent with portability lessons learned
elsewhere in this repo's grammars.

**A known, inherent ambiguity left unresolved, matching real Ruby:** a
bare identifier followed by what looks like an argument list (`foo bar,
baz`) is genuinely ambiguous between "a local variable reference" and
"a method call with no explicit receiver" without knowing which local
variables are already in scope -- real Ruby resolves this with its own
parser state tracking locally-assigned names, which this grammar does
not attempt to replicate; it simply permits both readings structurally.

Entry rule: `program`.

## A pre-existing, unrelated directory

This directory already contained a `gen/` subdirectory of generated
`Corundum...` Java sources before this grammar was added -- clearly
leftover build output from a different grammar (`corundum`), not a
Ruby grammar, and not tracked or referenced by git (it matches a
`.gitignore` pattern). It has been left in place rather than deleted
without being asked to.

## Examples

The `examples/` directory contains 10 Ruby programs: `puts "Hello,
World!"`; a class with `initialize`/instance variables and string
interpolation; `if`/`elsif`/`else`, a block (`each do |n| ... end`),
`while`, and `case`/`when` with ranges; hash and array literals
including `select`/`each` with block destructuring; `begin`/`rescue`/
`else`/`ensure` plus the implicit-rescue `def` form; a `module`
containing a `class` with an endless method and `::`-qualified
constant access; a `lambda`, multiple assignment (including a swap),
and a method with splat/keyword/double-splat parameters; the ternary
operator and safe navigation (`&.`); operator method definitions
(`def +`, `def ==`) on a small `Vector` class; and `unless`/`until`/
`for` loops together with modifier-`if`/`unless`.
