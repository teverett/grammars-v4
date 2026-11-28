parser grammar TclParser;

options { tokenVocab = TclLexer; }

// This grammar covers only Tcl's own syntax layer -- the twelve rules of
// the "Dodekalogue" governing how a script divides into commands and
// words, and how a word's text is built from literal characters,
// variable/command/backslash substitution, and brace/quote grouping.
// It deliberately does NOT know anything about what any individual
// command (set, proc, if, expr, while, ...) does with its word
// arguments at runtime -- for instance, a braced argument to `expr` or
// `if` is, as far as this grammar is concerned, just an ordinary braced
// word, since the arithmetic/boolean expression syntax inside it is
// interpreted later by the `expr` command itself, not by the Tcl
// parser. See README.md Notes.

script
    : scriptBody EOF
    ;

// A nested script (inside "[...]" command substitution) has exactly
// the same shape as a top-level one, but must not itself demand EOF --
// it is followed by the substitution's closing ']', not end of input.
scriptBody
    : sep* (command (sep+ command)*)? sep*
    ;

sep
    : SEMI
    | NEWLINE
    ;

command
    : commentCmd
    | word+
    ;

// Rule [10]: '#' is a comment only as the first character of a
// command's first word, and runs to the next newline (not semicolon).
// Modeled here purely by grammar position -- this alternative is only
// reachable when HASH is the very first token of a command -- rather
// than by any lexer-level position check. See README.md Notes and the
// `mad`/`spss` grammars elsewhere in this repo for the same pattern.
commentCmd
    : HASH (~NEWLINE)*
    ;

word
    : EXPAND wordBody
    | wordBody
    ;

wordBody
    : bareWord
    | quotedWord
    | braceWord
    ;

// A bare word's first piece may not be '{', '}', or "{*}" -- a word
// starting with '{' is always the start of a braceWord (rule [6]) or an
// EXPAND marker, never a bareWord whose first piece happens to be a
// literal brace. A brace appearing after that first piece, mid-word, is
// an ordinary literal character (e.g. "foo{bar}" is one plain word),
// which is what the trailing wordPiece* allows.
bareWord
    : firstWordPiece wordPiece*
    ;

firstWordPiece
    : TEXT
    | VARNAME
    | DOLLAR varRef
    | LBRACK scriptBody RBRACK
    | BACKSLASH_ESCAPE
    | BACKSLASH_NEWLINE
    | LPAREN
    | RPAREN
    | STAR
    | HASH
    ;

wordPiece
    : firstWordPiece
    | LBRACE
    | RBRACE
    | EXPAND
    ;

// Rule [4]: substitutions happen inside double quotes, but semicolons,
// close brackets, and whitespace are ordinary characters there (they
// are, since none of those have their own alternative in quotedPiece
// below -- they simply fall into TEXT/other-piece content, the same as
// in a bare word).
quotedWord
    : DQUOTE quotedPiece* DQUOTE
    ;

quotedPiece
    : TEXT
    | VARNAME
    | DOLLAR varRef
    | LBRACK scriptBody RBRACK
    | BACKSLASH_ESCAPE
    | BACKSLASH_NEWLINE
    | LPAREN
    | RPAREN
    | STAR
    | HASH
    | SEMI
    | LBRACE
    | RBRACE
    | EXPAND
    ;

// Rule [6]: a braced word is exactly the raw text between matching
// braces -- no substitution at all, except the backslash-newline
// prepass -- with nesting tracked here by parser recursion rather than
// a lexer action, so an escaped brace (which the lexer has already
// folded into one BACKSLASH_ESCAPE token, never a bare LBRACE/RBRACE)
// correctly does not count toward that nesting.
braceWord
    : LBRACE braceContent* RBRACE
    ;

braceContent
    : braceWord
    | BACKSLASH_NEWLINE
    | ~(LBRACE | RBRACE)
    ;

// Rule [8]: $name, $name(index), and ${name}.
varRef
    : VARNAME (LPAREN indexPiece* RPAREN)?
    | LBRACE braceVarName RBRACE
    ;

// "${name}": any characters except '}', with no further substitution.
braceVarName
    : ~RBRACE*
    ;

// Index content allows nested command/variable/backslash substitution
// (rule [8]), stopping at the array reference's own closing ')'.
indexPiece
    : TEXT
    | VARNAME
    | LPAREN
    | DOLLAR varRef
    | LBRACK scriptBody RBRACK
    | BACKSLASH_ESCAPE
    | BACKSLASH_NEWLINE
    | STAR
    | HASH
    ;
