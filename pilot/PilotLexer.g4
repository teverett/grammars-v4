lexer grammar PilotLexer;

// This grammar uses two lexer modes to avoid a genuine ambiguity in
// PILOT's surface syntax: a line's command letter and its optional Y/N
// suffix are written with no separator (e.g. "TY:"), which, if letters
// were tokenized the same way everywhere, would be indistinguishable
// from (and on pure longest-match would lose to) a two-letter
// identifier/word "TY". DEFAULT mode (before the ':') only ever needs
// single command letters, so it has no multi-letter identifier rule to
// compete with them; OPERAND mode (after the ':', entered by COLON, or
// after a '*' label marker) is where identifiers, match words, and
// variable references are recognized. See README.md Notes.

WS: [ \t]+ -> skip;
NEWLINE: ('\r'? '\n')+;

// ---------- Command letters (confirmed by Wikipedia's "PILOT" article) ----------
CMD_T: 'T';
CMD_A: 'A';
CMD_C: 'C';
CMD_D: 'D';
CMD_E: 'E';
CMD_J: 'J';
CMD_M: 'M';
CMD_N: 'N';
CMD_R: 'R';
CMD_U: 'U';
CMD_Y: 'Y';

LPAREN: '(';
RPAREN: ')';
COMMA: ',';
LE: '<=';
GE: '>=';
NE: '<>';
LT: '<';
GT: '>';
EQ: '=';
PLUS: '+';
MINUS: '-';
SLASH: '/';
STARSTAR: '**';

DOLLARVAR: '$' [A-Za-z] [A-Za-z0-9]*;
HASHVAR: '#' [A-Za-z] [A-Za-z0-9]*;
NUMBER: [0-9]+ ('.' [0-9]+)?;

STAR: '*' -> pushMode(OPERAND);
COLON: ':' -> pushMode(OPERAND);

mode OPERAND;

OP_WS: [ \t]+ -> skip;
OP_NEWLINE: ('\r'? '\n')+ -> popMode, type(NEWLINE);

OP_STAR: '*' -> type(STAR);
OP_LPAREN: '(' -> type(LPAREN);
OP_RPAREN: ')' -> type(RPAREN);
OP_COMMA: ',' -> type(COMMA);
OP_LE: '<=' -> type(LE);
OP_GE: '>=' -> type(GE);
OP_NE: '<>' -> type(NE);
OP_LT: '<' -> type(LT);
OP_GT: '>' -> type(GT);
OP_EQ: '=' -> type(EQ);
OP_PLUS: '+' -> type(PLUS);
OP_MINUS: '-' -> type(MINUS);
OP_SLASH: '/' -> type(SLASH);
OP_STARSTAR: '**' -> type(STARSTAR);
OP_DOLLARVAR: '$' [A-Za-z] [A-Za-z0-9]* -> type(DOLLARVAR);
OP_HASHVAR: '#' [A-Za-z] [A-Za-z0-9]* -> type(HASHVAR);
OP_NUMBER: [0-9]+ ('.' [0-9]+)? -> type(NUMBER);

IDENTIFIER: [A-Za-z] [A-Za-z0-9]*;

// Any other run of printable characters, used for the free-running text
// of T:/R: output and for literal (non-variable) M: match targets.
WORD: ~[ \t\r\n*():,<>=+\-/$#]+;
