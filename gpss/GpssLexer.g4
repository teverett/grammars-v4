lexer grammar GpssLexer;

// GPSS (General Purpose Simulation System) is a block-structured,
// transaction-flow discrete-event simulation language created by Geoffrey
// Gordon at IBM in 1961. A GPSS model is a sequence of statements, one per
// line, each an optional label followed by a block/command keyword (e.g.
// GENERATE, QUEUE, SEIZE, ADVANCE, RELEASE, TERMINATE) and a comma-
// separated operand list; "transactions" flow through the resulting block
// diagram, modeling entities moving through a system over simulated time.
//
// This grammar follows the free-form statement syntax used by modern GPSS
// World (Minuteman Software), including its "';' starts a comment that
// runs to end of line" convention, rather than the original fixed-column
// card-image format (where a line beginning with '*' in column 1 was a
// full-statement comment) -- see README.md for why.

SIMULATE: 'SIMULATE';
GENERATE: 'GENERATE';
TERMINATE: 'TERMINATE';
QUEUE: 'QUEUE';
DEPART: 'DEPART';
SEIZE: 'SEIZE';
RELEASE: 'RELEASE';
PREEMPT: 'PREEMPT';
RETURN: 'RETURN';
ADVANCE: 'ADVANCE';
ENTER: 'ENTER';
LEAVE: 'LEAVE';
ASSIGN: 'ASSIGN';
TRANSFER: 'TRANSFER';
TEST: 'TEST';
GATE: 'GATE';
PRIORITY: 'PRIORITY';
LOOP: 'LOOP';
MARK: 'MARK';
TABULATE: 'TABULATE';
SAVEVALUE: 'SAVEVALUE';
SPLIT: 'SPLIT';
ASSEMBLE: 'ASSEMBLE';
START: 'START';
END: 'END';
STORAGE: 'STORAGE';
FUNCTION: 'FUNCTION';
VARIABLE: 'VARIABLE';
TABLE: 'TABLE';

IDENTIFIER: [A-Za-z] [A-Za-z0-9_.]*;

REAL_LIT: DIGIT+ '.' DIGIT+;
INT_LIT: DIGIT+;
fragment DIGIT: [0-9];

STRING_LIT: '\'' (~['\r\n])* '\'';

LPAREN: '(';
RPAREN: ')';
PLUS: '+';
MINUS: '-';
STAR: '*';
SLASH: '/';
DOLLAR: '$';
COMMA: ',';
AT: '@';

LINE_COMMENT: ';' ~[\r\n]* -> skip;
WS: [ \t]+ -> skip;
NEWLINE: '\r'? '\n';
