lexer grammar Pop2Lexer;

// POP-2 is a list-processing / functional programming language designed
// by Robin Popplestone and Rod Burstall at the University of Edinburgh,
// described in their 1968/1971 "POP-2 Reference Manual". It is an
// ALGOL-like language with one famous inversion: assignment is written
// "<expression> -> <variable>;" (value flows left to right into the
// variable), reflecting POP-2's underlying operand-stack evaluation
// model. This grammar is built directly from the POP-2 Reference Manual
// (Burstall & Popplestone) -- see README.md for exactly which constructs
// were verified against it and which were simplified or omitted.

VARS: 'vars';
FUNCTION: 'function';
LAMBDA: 'lambda';
END: 'end';
IF: 'if';
THEN: 'then';
ELSEIF: 'elseif';
ELSE: 'else';
CLOSE: 'close';
GOTO: 'goto';
RETURN: 'return';
AND: 'and';
OR: 'or';
NOT: 'not';

// "The word comment and all characters after it up to and including the
// next semicolon are ignored." (POP-2 Reference Manual, section 5.6).
COMMENT: 'comment' ~[;]* ';' -> skip;

IDENTIFIER: [A-Za-z] [A-Za-z0-9]*;

INT_LIT: '8:' OCTALDIGIT+ | '2:' BINARYDIGIT+ | DIGIT+;
fragment OCTALDIGIT: [0-7];
fragment BINARYDIGIT: [01];
fragment DIGIT: [0-9];

REAL_LIT: DIGIT* '.' DIGIT+ ('10' [+-] DIGIT+)?;

WORD_LIT: '"' (~["\r\n])* '"';

ARROW: '->';
LE: '<=';
GE: '>=';
EQ: '=';
LT: '<';
GT: '>';
PLUS: '+';
MINUS: '-';
STAR: '*';
SLASH: '/';
LPAREN: '(';
RPAREN: ')';
LBRACK: '[';
RBRACK: ']';
PERCENT: '%';
COMMA: ',';
COLON: ':';
SEMI: ';';

WS: [ \t\r\n\f]+ -> skip;
