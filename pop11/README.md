# POP-11 Grammar

[POP-11](https://en.wikipedia.org/wiki/POP-11) is a list-processing and
functional programming language, the successor to [POP-2](../pop2), and
the core language of the "Poplog" AI programming environment developed
from the early 1980s at the Universities of Sussex and Edinburgh. It keeps
POP-2's reversed assignment operator (`<expression> -> <variable>;`) but
replaces POP-2's bare `function ... end` / `if ... close` syntax with
explicit, construct-specific closing keywords (`define ... enddefine`,
`if ... endif`, `for ... endfor`, ...), and adds dedicated `while` and
`repeat` loops that POP-2 never had.

## Source

https://en.wikipedia.org/wiki/POP-11

## Specification

No live, authoritative POP-11/Poplog reference manual could be reached
while researching this grammar: `poplog.org` resolves but is an unrelated
site (not Poplog-related), `cs.bham.ac.uk/research/projects/poplog` and its
linked teaching pages redirect to an archive host
(`poplogarchive.getpoplog.org`) that serves a loosely-related personal
project homepage rather than the Pop-11 Primer or reference manual, and a
direct fetch of `poplogarchive.getpoplog.org/primer` failed outright. One
archived teaching file *was* reachable, at

https://poplogarchive.getpoplog.org/teach/river

and supplied several of the syntax facts below. The rest come from the
Wikipedia article above, whose own worked example is quoted directly.

## Notes

This grammar is a documented mix of confirmed facts and plausible,
pattern-consistent extensions -- please read this section before trusting
any specific construct:

**Confirmed against a primary/secondary source:**
- `define <name>(<params>) [-> <result-var>]; <body> enddefine;` --
  Wikipedia's own example, quoted verbatim:
  `define Double(Source) -> Result; Source*2 -> Result; enddefine;`
- Assignment is still POP-2's reversed `<expression> -> <variable>;`
  (same source).
- `for <var> in <expression> do <body> endfor;` (Wikipedia).
- `unless <condition> then <body> [else <body>] endunless;` (Wikipedia).
- `;;;` line comments, confirmed from the archived teaching file
  (`lib river; ;;; this loads the river library`).
- List literals are space-separated items in `[...]`, optionally splicing
  in a variable's value with a leading `^`, confirmed from the same file:
  `[Putting in ^thing]`.
- `==>` prints the value of an expression, confirmed from the same file
  (`database ==>`).
- `define`/`enddefine` has a `procedure`/`endprocedure` synonym pair; this
  is widely known/attested but was not independently re-confirmed against
  one of the sources reached above.

**Plausible, pattern-consistent, but NOT independently confirmed:**
- `if <cond> then <body> [elseif <cond> then <body>]* [else <body>]
  endif;` -- only the negated `unless`/`endunless` form was directly
  confirmed; `if`/`endif` is modeled by analogy (POP-11 consistently uses
  an `end<keyword>` closer for every block construct, and `endunless`'s
  existence strongly implies a base `if`/`endif` form exists too).
- `while <cond> do <body> endwhile;` and
  `repeat <body> until <cond> endrepeat;` -- POP-11 is widely known to
  have added real loop keywords over POP-2 (which only had label/`goto`
  looping), but no worked example of either was found in the sources
  reached while researching this grammar.
- `/* ... */` block comments, often mentioned for POP-11 elsewhere, were
  not confirmed here and are deliberately **not** modeled -- only `;;;`
  line comments are.
- Numeric literal forms (decimal, `8:`-octal, `2:`-binary, real with a
  `10+`/`10-` exponent) and double-quoted "word" literals are carried over
  unchanged from this repo's [POP-2 grammar](../pop2), since POP-11
  inherits POP-2's item/value model, but were not independently
  re-verified against a POP-11-specific source.
- Single-quoted string literals (`'like this'`) are modeled as distinct
  from double-quoted words, matching general knowledge of Poplog's string
  vs. word distinction, but likewise not independently confirmed here.
- `goto`/labels are deliberately **not** modeled: POP-11's real loop
  keywords make them far less central than in POP-2, and no primary
  source for POP-11's specific label syntax was reached.

Entry rule: `program`.

## Examples

The `examples/` directory contains 10 POP-11 programs exercising: the
`define`/`enddefine` function form (Wikipedia's own `Double` example), a
`for ... in ... do ... endfor` loop, an `unless ... then ... endunless`
conditional, an `if`/`elseif`/`else`/`endif` conditional, a `while ...
do ... endwhile` loop, a `repeat ... until ... endrepeat` loop, a list
literal with `^`-splicing, the `procedure`/`endprocedure` synonym form,
`;;;` comments together with the `==>` print operator, and array/updater-
style assignment (`3 -> a(4);`) combined with a two-parameter function.
