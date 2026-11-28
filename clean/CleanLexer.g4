lexer grammar CleanLexer;

LINE_COMMENT: '//' ~[\r\n]* -> skip;
BLOCK_COMMENT: '/*' .*? '*/' -> skip;
WS: [ \t\r\n\f\u000B]+ -> skip;

// ---------- Reserved words ----------
MODULE: 'module';
IMPLEMENTATION: 'implementation';
DEFINITION: 'definition';
SYSTEM: 'system';
IMPORT: 'import';
FROM: 'from';
CLASS: 'class';
INSTANCE: 'instance';
SPECIAL: 'special';
DERIVE: 'derive';
EXPORT: 'export';
GENERIC: 'generic';
FOREIGN: 'foreign';
CODE: 'code';
INFIX: 'infix';
INFIXL: 'infixl';
INFIXR: 'infixr';
LET: 'let';
IN: 'in';
WHERE: 'where';
WITH: 'with';
CASE: 'case';
OF: 'of';
IF: 'if';
OTHERWISE: 'otherwise';

// ---------- Reserved multi-char symbols (ordering matters: longest/most
// specific first so they win over FunnyId / shorter symbols) ----------
ARRCOMPGEN: '<-:';
LISTCOMPGEN: '<-';
TYPESYN: ':==';
FORCEEQ: '=>';
BINDEQ: '=:';
FORCEBIND: '#!';
ARROW: '->';
DCOLON: '::';
UNIQLE: '<=';
COMPSEP: '\\\\';
DOTDOT: '..';
UNDERSCORE: '_';
STRICTLISTOPEN: '[!';
UNBOXLISTOPEN: '[#';
OVERLOADLISTOPEN: '[|';

LPAREN: '(';
RPAREN: ')';
LBRACK: '[';
RBRACK: ']';
LBRACE: '{';
RBRACE: '}';
COMMA: ',';
SEMI: ';';
PIPE: '|';
COLON: ':';
AMP: '&';
BANG: '!';
HASH: '#';
STAR: '*';
DOT: '.';
BACKSLASH: '\\';
EQUALS: '=';

BOOL_LIT: 'True' | 'False';

// `Start` is the one capitalized identifier that names an ordinary function
// (the program's entry point) rather than a constructor/type/class/module,
// so it needs its own token ahead of the general UPPER_ID rule.
START: 'Start';

UPPER_ID: [A-Z] ID_CHAR*;
LOWER_ID: [a-z] ID_CHAR* (SQUOTE)*;
fragment SQUOTE: '\'';
fragment ID_CHAR: [a-zA-Z0-9_];

REAL_LIT: DIGIT+ '.' DIGIT+ ([eE] [+-]? DIGIT+)?;
INT_LIT: '0x' HEXDIGIT+
       | '0' OCTDIGIT+
       | DIGIT+
       ;
fragment DIGIT: [0-9];
fragment HEXDIGIT: [0-9a-fA-F];
fragment OCTDIGIT: [0-7];

CHAR_LIT: '\'' (CHAR_ESC | ~['\\]) '\'';
STRING_LIT: '"' (CHAR_ESC | ~["\\])* '"';
fragment CHAR_ESC: '\\' ([nrfbtv\\'"] | 'o' OCTDIGIT+ | 'x' HEXDIGIT+ | DIGIT+);

// FunnyId: a run of "special characters" forming an operator-like name.
// Must come after all the fixed reserved-symbol rules above so those win.
FUNNY_ID: SPECIAL_CHAR+;
fragment SPECIAL_CHAR: [~@#$%^?!+<>/=|&:*\\-];
