lexer grammar ShortCodeLexer;

WS: [ \t]+ -> skip;
NEWLINE: ('\r'? '\n')+;

LPAREN: '(';
RPAREN: ')';
EQ: '=';
PLUS: '+';
MINUS: '-';
STAR: '*';
SLASH: '/';

// Variables are named with a letter, confirmed to be 'X' or 'Y' in the
// one surviving worked example, followed by a digit sequence (X1, Y1,
// X3). See README.md Notes.
VAR: [XY] [0-9]+;

NUMBER: [0-9]+ ('.' [0-9]+)?;
