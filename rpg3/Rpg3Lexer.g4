lexer grammar Rpg3Lexer;

// RPG III is the third generation of IBM's RPG ("Report Program
// Generator") language, used on the IBM System/38 and later the AS/400
// (iSeries). A traditional RPG III program is a fixed-column, "card-image"
// source made of specification lines, each identified by a single-letter
// form type in a specific source column: H (control/header), F (file
// description), I (input), C (calculation), and O (output).
//
// Faithfully modeling fixed-column RPG III would require a lexer that
// tracks character column position to decide what each field on a line
// means -- that requires target-specific action code, which this repo
// avoids because desc.xml generates drivers for many ANTLR targets (Java,
// C#, Go, Python, JavaScript, ...) that don't share a portable way to
// express it. This grammar instead models the same specification lines
// and fields in the same left-to-right order, delimited by whitespace and
// a handful of punctuation marks (parentheses around indicator lists, a
// hyphen for a from-to column range) instead of fixed source columns. See
// README.md for the complete list of simplifications.

H_SPEC: 'H';
F_SPEC: 'F';
I_SPEC: 'I';
C_SPEC: 'C';
O_SPEC: 'O';

// RPG III calculation-specification operation codes (a representative
// subset of the full op-code list).
ADD: 'ADD';
SUB: 'SUB';
MULT: 'MULT';
DIV: 'DIV';
MOVE: 'MOVE';
MOVEL: 'MOVEL';
ZADD: 'Z-ADD';
ZSUB: 'Z-SUB';
COMP: 'COMP';
IFEQ: 'IFEQ';
IFGT: 'IFGT';
IFLT: 'IFLT';
IFGE: 'IFGE';
IFLE: 'IFLE';
IFNE: 'IFNE';
ELSE: 'ELSE';
ENDIF: 'ENDIF';
DO: 'DO';
ENDDO: 'ENDDO';
GOTO: 'GOTO';
TAG: 'TAG';
EXCPT: 'EXCPT';
CALL: 'CALL';
PARM: 'PARM';
CHAIN: 'CHAIN';
READ: 'READ';
WRITE: 'WRITE';
UPDATE: 'UPDATE';
DELETE: 'DELETE';
SETON: 'SETON';
SETOF: 'SETOF';
RETRN: 'RETRN';
EXSR: 'EXSR';
BEGSR: 'BEGSR';
ENDSR: 'ENDSR';
ENDOP: 'END';

IDENTIFIER: [A-Za-z#$@] [A-Za-z0-9#$@_]*;

INT_LIT: DIGIT+;
fragment DIGIT: [0-9];

STRING_LIT: '\'' (~['\r\n])* '\'';

LPAREN: '(';
RPAREN: ')';
COMMA: ',';
MINUS: '-';

LINE_COMMENT: '*' ~[\r\n]* -> skip;
WS: [ \t]+ -> skip;
NEWLINE: '\r'? '\n';
