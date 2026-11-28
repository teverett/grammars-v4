lexer grammar MesaLexer;

LINE_COMMENT: '--' ~[\r\n]* -> skip;
WS: [ \t\r\n\f]+ -> skip;

// ---------- Reserved words (Mesa keywords are conventionally uppercase) ----------
DIRECTORY: 'DIRECTORY';
DEFINITIONS: 'DEFINITIONS';
PROGRAM: 'PROGRAM';
IMPORTS: 'IMPORTS';
EXPORTS: 'EXPORTS';
FROM: 'FROM';
USING: 'USING';
TYPE: 'TYPE';
RECORD: 'RECORD';
ARRAY: 'ARRAY';
POINTER: 'POINTER';
TO: 'TO';
OF: 'OF';
PROC: 'PROC';
RETURNS: 'RETURNS';
RETURN: 'RETURN';
BEGIN: 'BEGIN';
END: 'END';
IF: 'IF';
THEN: 'THEN';
ELSE: 'ELSE';
FOR: 'FOR';
IN: 'IN';
DO: 'DO';
WHILE: 'WHILE';
LOOP: 'LOOP';
ENDLOOP: 'ENDLOOP';
EXIT: 'EXIT';
SELECT: 'SELECT';
ENDCASE: 'ENDCASE';
SIGNAL: 'SIGNAL';
ERROR: 'ERROR';
ABORT: 'ABORT';
RETRY: 'RETRY';
CATCH: 'CATCH';
CONTINUE: 'CONTINUE';
REJECT: 'REJECT';
RESUME: 'RESUME';

// ---------- Punctuation / operators ----------
LBRACK: '[';
RBRACK: ']';
LPAREN: '(';
RPAREN: ')';
COMMA: ',';
SEMI: ';';
COLON: ':';
DOTDOT: '..';
DOT: '.';
BANG: '!';
DOUBLE_ARROW: '=>';

// Mesa's native assignment token is a left-pointing arrow, available on
// the Alto's character set; '_' is the ASCII substitute seen in later
// Mesa/Cedar listings on conventional terminals. See README.md Notes.
ASSIGN: '←' | '_';

EQ: '=';
NE: '#';
LE: '<=';
GE: '>=';
LT: '<';
GT: '>';
PLUS: '+';
MINUS: '-';
STAR: '*';
SLASH: '/';

NUMBER: DIGIT+ ('.' DIGIT+)?
      | DIGIT+ 'B'
      | DIGIT+ 'C'
      | DIGIT+ 'H'
      | DIGIT+ 'D'
      ;
fragment DIGIT: [0-9];

STRING: '"' (~["] | '""')* '"';

// Mesa identifiers are letter-led and may not contain underscore (reserved
// for the ASSIGN substitute above); camelCase was the usual convention.
IDENTIFIER: [A-Za-z] [A-Za-z0-9]*;
