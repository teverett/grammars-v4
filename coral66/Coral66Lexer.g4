lexer grammar Coral66Lexer;

// `COMMENT ... ;` is confirmed by the Official Definition: "the word
// COMMENT followed by text and terminated by a semi-colon." The
// alternative "(...)" bracketed-comment form directly after a ';' is
// NOT implemented, since recognizing it would require tracking bracket
// nesting in the lexer and would otherwise be indistinguishable from an
// ordinary parenthesized expression. See README.md Notes.
COMMENT_STMT: 'COMMENT' ~[;]* ';' -> skip;

WS: [ \t\r\n\f]+ -> skip;

// ---------- Reserved words (confirmed by the Official Definition) ----------
FLOATING: 'FLOATING';
FIXED: 'FIXED';
INTEGER: 'INTEGER';
ARRAY: 'ARRAY';
SWITCH: 'SWITCH';
OVERLAY: 'OVERLAY';
WITH: 'WITH';
TABLE: 'TABLE';
PRESET: 'PRESET';
UNSIGNED: 'UNSIGNED';
SIGNED: 'SIGNED';
COMMON: 'COMMON';
ABSOLUTE: 'ABSOLUTE';
BEGIN: 'BEGIN';
END: 'END';
VALUE: 'VALUE';
LOCATION: 'LOCATION';
LABEL: 'LABEL';
PROCEDURE: 'PROCEDURE';
RECURSIVE: 'RECURSIVE';
ANSWER: 'ANSWER';
GOTO: 'GOTO';
IF: 'IF';
THEN: 'THEN';
ELSE: 'ELSE';
FOR: 'FOR';
DO: 'DO';
STEP: 'STEP';
UNTIL: 'UNTIL';
WHILE: 'WHILE';
OR: 'OR';
AND: 'AND';
OCTAL: 'OCTAL';
LITERAL: 'LITERAL';
CODE: 'CODE';
BITS: 'BITS';
DIFFER: 'DIFFER';
UNION: 'UNION';
MASK: 'MASK';
DEFINE: 'DEFINE';
DELETE: 'DELETE';

// ---------- Punctuation / operators ----------
LPAREN: '(';
RPAREN: ')';
LBRACK: '[';
RBRACK: ']';
SEMI: ';';
COLON: ':';
COMMA: ',';
ASSIGN: '<-';
LE: '<=';
NE: '<>';
LT: '<';
GE: '>=';
GT: '>';
EQ: '=';
PLUS: '+';
MINUS: '-';
STAR: '*';
SLASH: '/';

// The exact OCR glyph for the macro-definition brackets could only be
// partly confirmed: the opening '«' is directly attested, the closing
// '»' is this grammar's reconstruction by pairing. See README.md Notes.
MACRO_OPEN: '«';
MACRO_CLOSE: '»';

// Strings: the Official Definition's own quote-mark glyph is illegible
// in the only available scan; this grammar uses a single quote as a
// documented ASCII substitute. See README.md Notes.
STRING: '\'' (~['\r\n])* '\'';

INTEGER_LIT: [0-9]+;
REAL_LIT: [0-9]+ '.' [0-9]+;

IDENTIFIER: [a-z] [a-z0-9]*;
