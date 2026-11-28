lexer grammar MadLexer;

// `;` introduces a line comment. Neither the original column-11 "R"
// remark marker nor GOM's leading-"*" convention can be expressed
// portably here: both need a "start of line" check, and ANTLR lexer
// semantic predicates for that (e.g. Java's getCharPositionInLine())
// are host-language-specific and do not compile for every target this
// grammar is generated for (Go, in particular, uses a differently-named
// method). `;` is never otherwise used by this grammar, so it needs no
// position check at all. See README.md Notes.
LINE_COMMENT: ';' ~[\r\n]* -> skip;

NEWLINE: ('\r'? '\n')+;
WS: [ \t]+ -> skip;

// ---------- Dot-delimited operators (must precede the generic DOT token)
DOTLE: '.LE.';
DOTGE: '.GE.';
DOTNE: '.NE.';
DOTLT: '.L.';
DOTGT: '.G.';
DOTEQ: '.E.';
DOTNOT: '.NOT.';
DOTAND: '.AND.';
DOTOR: '.OR.';
DOTEXOR: '.EXOR.';
DOTEQV: '.EQV.';
DOTTHEN: '.THEN.';
DOTABS: '.ABS.';
DOTPOW: '.P.';
DOTBNOT: '.N.';
DOTBAND: '.A.';
DOTBOR: '.V.';
DOTBXOR: '.EV.';
DOTLSHIFT: '.LS.';
DOTRSHIFT: '.RS.';

// ---------- Reserved words ----------
WHENEVER: 'WHENEVER';
OTHERWISE: 'OTHERWISE';
CONTINUE: 'CONTINUE';
TRANSFER: 'TRANSFER';
TO: 'TO';
THROUGH: 'THROUGH';
FOR: 'FOR';
VALUES: 'VALUES';
OF: 'OF';
END: 'END';
PROGRAM: 'PROGRAM';
CONDITIONAL: 'CONDITIONAL';
OR: 'OR';
INTEGER: 'INTEGER';
FLOATING: 'FLOATING';
POINT: 'POINT';
BOOLEAN: 'BOOLEAN';
FUNCTION: 'FUNCTION';
NAME: 'NAME';
STATEMENT: 'STATEMENT';
LABEL: 'LABEL';
MODE: 'MODE';
NUMBER_KW: 'NUMBER';
NORMAL: 'NORMAL';
IS: 'IS';
DIMENSION: 'DIMENSION';
VECTOR: 'VECTOR';
PRINT: 'PRINT';
FORMAT: 'FORMAT';
COMMENT: 'COMMENT';
RESULTS: 'RESULTS';
READ: 'READ';
DATA: 'DATA';
INTERNAL: 'INTERNAL';
EXTERNAL: 'EXTERNAL';
ENTRY: 'ENTRY';
RETURN: 'RETURN';
EXECUTE: 'EXECUTE';

LPAREN: '(';
RPAREN: ')';
COMMA: ',';
EQUALS: '=';
PLUS: '+';
MINUS: '-';
STAR: '*';
SLASH: '/';
DOT: '.';

BOOL_LIT: [01] 'B';

// The fractional part always requires at least one digit after the dot
// (no bare trailing-dot literals like "3."), so that a number immediately
// followed by a dot-delimited operator (e.g. "0.AND.", "N.G.0") always
// leaves that operator's leading dot free to lex as its own token. See
// README.md Notes.
NUMBER: (DIGIT+ ('.' DIGIT+)? | '.' DIGIT+) ([eE] [+-]? DIGIT+)? ('K' DIGIT*)?;
fragment DIGIT: [0-9];

STRING: '$' ('$$' | ~[$\r\n])* '$';

IDENTIFIER: [A-Za-z] [A-Za-z0-9_]*;
