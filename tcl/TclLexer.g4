lexer grammar TclLexer;

WS: [ \t]+ -> skip;
NEWLINE: '\r'? '\n';
SEMI: ';';

// "{*}" is matched as a single 3-character token (ahead of the general
// LBRACE rule, and longer, so it always wins) marking the argument-
// expansion form from rule [5] of the Tcl "Dodekalogue". The precise
// condition in that rule -- the marker must be immediately followed by
// a non-whitespace character to trigger expansion, otherwise "{*}" is
// just an ordinary braced word containing "*" -- is not checked here,
// since whitespace is discarded before the parser ever sees it. See
// README.md Notes.
EXPAND: '{*}';

LBRACE: '{';
RBRACE: '}';
LBRACK: '[';
RBRACK: ']';
DQUOTE: '"';
DOLLAR: '$';
LPAREN: '(';
RPAREN: ')';
STAR: '*';
HASH: '#';

// Rule [9]'s backslash-newline continuation: folded to a single space
// wherever it occurs, including inside braces, as its own token so
// braceBody doesn't count the newline it consumes toward anything.
BACKSLASH_NEWLINE: '\\' '\r'? '\n' [ \t]*;

// Every other backslash substitution form from rule [9] -- \a \b \f \n
// \r \t \v \\, an escaped special character (\{ \} \$ \[ \] \" \;),
// octal (\ooo), hex (\xhh), and Unicode (\uhhhh / \Uhhhhhhhh) -- is
// matched generically here; this grammar checks only that a backslash
// is followed by at least one more character, not the escape's exact
// shape.
BACKSLASH_ESCAPE: '\\' .;

VARNAME: [A-Za-z0-9_]+ (':' ':' [A-Za-z0-9_]+)*;

// A run of otherwise-unremarkable characters. Every character that
// carries its own syntactic meaning somewhere in this grammar (layout,
// the command/word separators, and the substitution-introducing
// characters) has its own token above and so is excluded here. The
// first character additionally excludes letters/digits/underscore, so
// that TEXT can never start matching at a position where VARNAME also
// would -- otherwise, since VARNAME stops at a character like '!' that
// TEXT does not, the longer TEXT match would always win there and
// swallow a variable name together with following punctuation into one
// token (e.g. "$name!" would wrongly lex as DOLLAR + one token "name!"
// instead of DOLLAR + VARNAME("name") + TEXT("!")).
TEXT: ~[ \t\r\n;#$(){}[\]"\\*A-Za-z0-9_] ~[ \t\r\n;#$(){}[\]"\\*]*;
