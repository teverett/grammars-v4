lexer grammar CplLexer;

// `//` line comments are NOT attested for CPL itself in any source found
// during research; they are adopted here only as a plausible, clearly
// unconfirmed convenience. See README.md Notes.
LINE_COMMENT: '//' ~[\r\n]* -> skip;

WS: [ \t\r\n\f]+ -> skip;

// CPL's native section brackets: a plain section sign for the opening
// bracket, and a section sign overprinted with a slash -- rendered here
// with the Unicode combining long solidus overlay -- for the closing
// bracket, exactly as described by Richards, "How BCPL evolved from CPL"
// (2011). Curly braces are accepted as an equivalent, ASCII-typeable
// alternative. See README.md Notes.
SECTION_OPEN: '§';
SECTION_CLOSE: '§̸';
LBRACE: '{';
RBRACE: '}';

LPAREN: '(';
RPAREN: ')';
LBRACK: '[';
RBRACK: ']';

ASSIGN: ':=';
ARROW: '->';
REFDEF: '≃';   // '≃', reference (by-name) declaration
SUBSTDEF: '≡'; // '≡', substitution ("name") declaration
LE: '<=';
GE: '>=';
NE: '~=';
EQ: '=';
LT: '<';
GT: '>';
PLUS: '+';
MINUS: '-';
STAR: '*';
SLASH: '/';
BANG: '!';
AT: '@';
COMMA: ',';
SEMI: ';';

LET: 'let';
REC: 'rec';
AND: 'and';
IN: 'in';
WHERE: 'where';
VALUE: 'value';
OF: 'of';
RESULT: 'result';
IS: 'is';
IF: 'if';
THEN: 'then';
ELSE: 'else';
WHILE: 'while';
DO: 'do';
UNTIL: 'until';
REPEAT: 'repeat';
FOR: 'for';
TO: 'to';
BY: 'by';
TEST: 'test';
OR: 'or';
LV: 'LV';

NUMBER: DIGIT+
      | '#b' [01]+
      | '#o' [0-7]+
      | '#x' HEXDIGIT+
      ;
fragment DIGIT: [0-9];
fragment HEXDIGIT: [0-9a-fA-F];

STRING: '\'' (STR_ESC | ~['*])* '\''
      | '"' (STR_ESC | ~["*])* '"'
      ;
fragment STR_ESC: '*' .;

// A CPL identifier is either a single lower-case letter, or an upper-case
// letter followed by letters, digits, and dots, optionally followed by
// one or more trailing primes -- confirmed directly by Richards (2011).
IDENTIFIER: ([a-z] | [A-Z] IDCHAR*) '\''*;
fragment IDCHAR: [A-Za-z0-9.];
