lexer grammar IplLexer;

// `;`, `;;`, or `;;;` introduce a line comment in the .liplv transcription
// format this grammar targets. See README.md Notes.
LINE_COMMENT: ';' ';'? ';'? ~[\r\n]* -> skip;

WS: [ \t\r\n\f]+ -> skip;

LPAREN: '(';
RPAREN: ')';

KEYWORD: ':' [A-Za-z] [A-Za-z0-9_.]*;

STRING: '"' ('\\' . | '""' | ~["\\])* '"';
