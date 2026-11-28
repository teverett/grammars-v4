lexer grammar SpssLexer;

WS: [ \t]+ -> skip;
NEWLINE: ('\r'? '\n')+ -> skip;

// ---------- Reserved words confirmed as reserved identifiers by the PSPP
// manual's Tokens page, plus the command keywords this grammar models
// explicitly. See README.md Notes for which keywords are confirmed vs.
// drawn from general knowledge of SPSS command syntax.
ALL: 'ALL';
AND: 'AND';
BY: 'BY';
EQ: 'EQ';
GE: 'GE';
GT: 'GT';
LE: 'LE';
LT: 'LT';
NE: 'NE';
NOT: 'NOT';
OR: 'OR';
TO: 'TO';
WITH: 'WITH';

COMMENT_KW: 'COMMENT';
BEGIN_KW: 'BEGIN';
DATA_KW: 'DATA';
END_KW: 'END';
GET: 'GET';
FILE: 'FILE';
SAVE: 'SAVE';
OUTFILE: 'OUTFILE';
COMPUTE: 'COMPUTE';
IF: 'IF';
DO: 'DO';
ELSE: 'ELSE';
LOOP: 'LOOP';
RECODE: 'RECODE';
INTO: 'INTO';
THRU: 'THRU';
SELECT: 'SELECT';
VARIABLE: 'VARIABLE';
LABELS: 'LABELS';
VALUE: 'VALUE';
MISSING: 'MISSING';
VALUES: 'VALUES';
EXECUTE: 'EXECUTE';
FREE: 'FREE';
FIXED: 'FIXED';
LIST: 'LIST';

// ---------- Punctuators / operators (confirmed by the PSPP Tokens page) ----------
LPAREN: '(';
RPAREN: ')';
COMMA: ',';
SLASH: '/';
PLUS: '+';
MINUS: '-';
POW: '**';
STAR: '*';
LE_OP: '<=';
NE_OP: '<>';
LT_OP: '<';
GE_OP: '>=';
GT_OP: '>';
NE_OP2: '~=';
AMP: '&';
PIPE: '|';
ASSIGN: '=';
DOT: '.';

// Numbers never fold a bare trailing '.' into themselves (the decimal
// point always needs at least one digit after it), so that a number
// immediately followed by the command-terminator period is lexed as two
// tokens, matching the PSPP manual's own description of "8945." at the
// end of a line. See README.md Notes.
NUMBER: DIGIT+ ('.' DIGIT+)? ([eE] [+-]? DIGIT+)?
      | '.' DIGIT+ ([eE] [+-]? DIGIT+)?
      ;
fragment DIGIT: [0-9];

// Quoted strings (single or double quotes, doubled-quote-char escaping),
// with optional hex ('x'/'X') or Unicode ('u'/'U') prefixes, all
// confirmed by the PSPP Tokens page.
STRING: [xXuU]? '\'' ('\'\'' | ~['\r\n])* '\''
      | [xXuU]? '"' ('""' | ~["\r\n])* '"'
      ;

// Identifiers: letter/#/@ leading character, then letters/digits/_/$/#/@,
// with '.' allowed internally but never as the trailing character of the
// token (an internal '.' must always be followed by at least one more
// identifier character). Without that restriction, a name immediately
// followed by the command-terminator period with no space (e.g. "i.")
// would always be swallowed into the identifier as a single token,
// leaving no separate '.' for the parser to see -- the same class of
// problem as a trailing-dot numeric literal (see NUMBER above), and
// likewise not resolvable with a portable, non-greedy lexer rule other
// than disallowing the trailing dot. Case-insensitivity and the
// 64-significant-byte limit are not enforced lexically. See README.md
// Notes.
IDENTIFIER: [A-Za-z#@] IDCHAR* ('.' IDCHAR+)*;
fragment IDCHAR: [A-Za-z0-9_$#@];
