# Tcl Grammar

[Tcl](https://en.wikipedia.org/wiki/Tcl_(programming_language)) (Tool
Command Language) is a dynamic scripting language designed by John
Ousterhout, first appearing in 1988. Unlike most languages, its syntax
is not really a context-free grammar in the usual sense -- it is
formally defined by just twelve short rules, sometimes called the
"Dodekalogue," describing how a script splits into commands and words
and how a word's text is assembled from literal characters plus
variable, command, and backslash substitution. Everything else --
what `if`, `while`, `proc`, `expr`, or any other command actually does
with the words it receives -- is a runtime matter for that command, not
part of Tcl's own syntax.

## Source

https://en.wikipedia.org/wiki/Tcl_(programming_language)

## Specification

https://www.tcl-lang.org/man/tcl8.6/TclCmd/Tcl.htm (the official "Tcl"
manual page, which states the twelve syntax rules this grammar
implements). See also
https://www.tcl-lang.org/man/tcl8.6/TclCmd/expr.htm,
https://www.tcl-lang.org/man/tcl8.6/TclCmd/set.htm, and
https://www.tcl-lang.org/man/tcl8.6/TclCmd/proc.htm for the individual
commands referenced in Notes and in the examples below.

## Notes

**This grammar covers only Tcl's syntax layer, not any individual
command's semantics.** This is a deliberate scope decision described by
the Tcl manual page itself: words like `{$a + $b}` passed to `expr`, or
a braced body passed to `if`/`while`/`proc`, are -- as far as Tcl's own
parser is concerned -- just an ordinary braced word. The arithmetic or
boolean expression syntax inside an `expr` argument, and the procedure
body syntax inside a `proc` argument, are interpreted later by those
commands, not by the Tcl language parser. Consequently this grammar
does **not** have (and does not need) separate rules for `if` or
`while` conditions, `proc` bodies, or `expr`'s operator precedence --
every command, including all of these, is syntactically just a sequence
of words.

**The twelve rules, and how each is modeled:**
1. **Commands.** A script is one or more commands, separated by `;` or
   a newline.
2. **Evaluation.** (Not a syntax rule as such -- word-splitting plus
   substitution, then command dispatch.)
3. **Words.** Words are separated by whitespace; newlines separate
   commands, not words.
4. **Double-quoted words** (`"..."`) run to the next `"`; semicolons,
   `]`, and whitespace inside are ordinary characters, but command,
   variable, and backslash substitution still happen.
5. **Argument expansion** (`{*}word`) splits a following list into
   separate words. This grammar recognizes the literal `{*}` marker as
   its own token, but -- since whitespace is discarded before the
   parser sees anything -- does not check the rule's further condition
   that the marker must be immediately followed by a non-whitespace
   character to trigger expansion (as opposed to being an ordinary
   braced word containing just `*`). See the `EXPAND` token's comment
   in `TclLexer.g4`.
6. **Braces** (`{...}`): the word is exactly the raw text between
   matching braces, with no substitution at all except the
   backslash-newline fold, and nesting tracked by parser recursion (an
   escaped brace is never treated as a real `{`/`}` boundary, since the
   lexer has already folded it into a backslash-escape token before the
   parser ever sees it).
7. **Command substitution** (`[...]`): a nested script, substituted in
   place of the brackets; modeled by making the main `script` rule
   re-enter itself.
8. **Variable substitution**: `$name`, `$name(index)` (array element,
   with command/variable/backslash substitution performed on `index`),
   and `${name}` (literal characters up to the next `}`, no further
   substitution).
9. **Backslash substitution**: this grammar recognizes the shape of
   every escape form the rule describes (`\a \b \f \n \r \t \v`, `\\`,
   escaped specials, `\ooo`, `\xhh`, `\uhhhh`, `\Uhhhhhhhh`, and the
   backslash-newline continuation), but checks only that a backslash is
   followed by at least one more character -- it does not verify that
   an escape like `\x` or `\u` has a well-formed hex/octal digit
   sequence after it.
10. **Comments** (`#`): significant only as the first word of a
    command, running to the next newline (not the next semicolon).
    Recognized purely by grammar position -- `commentCmd` is only
    reachable as the very first thing in a `command` -- the same
    position-based pattern already used for this exact problem in this
    repo's `mad` and `spss` grammars, since a lexer-level "start of
    command" predicate would not compile portably across every target
    this grammar is generated for.
11. **Order of substitution / rescanning.** A purely semantic rule (the
    result of a substitution is not rescanned); nothing to add at the
    syntax level.
12. **Word boundaries.** Also semantic (substitution does not change
    word boundaries except for `{*}`); nothing to add syntactically.

**A genuine lexer-ambiguity fix worth noting:** a variable name (rule 8)
is restricted to letters, digits, underscore, and `::`, which is a
*subset* of the characters an ordinary word can contain. Naively, a
single generic "run of ordinary text" token would then always win a
longest-match contest against the stricter variable-name token whenever
the character immediately after a name wasn't whitespace (e.g. `$name!`
would wrongly lex as one token `name!` instead of a variable name
`name` followed by a separate `!`). Fixed by excluding
letters/digits/underscore from that generic token's own *first*
character, so it can never start matching at a position where the
variable-name token also would.

Entry rule: `script`.

## Examples

The `examples/` directory contains 10 Tcl scripts: `puts "Hello,
World!"`; `set`/`expr` (including the manual's own braced-vs-unbraced
substitution example); a `proc` definition with a default argument and
`upvar`, taken from the `proc` manual page; variable and nested command
substitution inside a double-quoted string; the manual's own
order-of-substitution example (`set y [set x 0][incr x][incr x]`);
array-element variables (`set anAry(msg) ...`, `$anAry(msg)`); backslash
escapes including a line continuation; the `#`-as-comment rule; `if`/
`while` with braced bodies; and the `{*}` argument-expansion marker.
