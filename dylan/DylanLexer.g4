lexer grammar DylanLexer;

LINE_COMMENT: '//' ~[\r\n]* -> skip;
BLOCK_COMMENT: '/*' .*? '*/' -> skip;
WS: [ \t\r\n\f]+ -> skip;

// #-words (must come before general '#' punctuation)
HASH_T: '#t';
HASH_F: '#f';
HASH_NEXT: '#next';
HASH_REST: '#rest';
HASH_ALL_KEYS: '#all-keys';
HASH_KEY: '#key';
HASH_INCLUDE: '#include';

UNIQUE_STRING: '#"' (ESC | ~["\\])* '"';

HASH_PAREN: '#(';
HASH_BRACKET: '#[';
HASH_HASH: '##';

NUMBER
    : SIGN? DIGIT+ ('.' DIGIT+)? EXPONENT?
    | SIGN? DIGIT+ EXPONENT
    | '#b' [01]+
    | '#o' [0-7]+
    | '#x' [0-9a-fA-F]+
    ;

fragment SIGN: [+-];
fragment DIGIT: [0-9];
fragment EXPONENT: [eEdD] SIGN? DIGIT+;

CHAR_LITERAL: '\'' (ESC | ~['\\]) '\'';
STRING: '"' (ESC | ~["\\])* '"';
fragment ESC: '\\' ([\\'"abefnrt0] | '<' [0-9a-fA-F]+ '>');

// Punctuation / operators (longest-match ordering matters)
COLONEQ: ':=';
COLONCOLON: '::';
ARROW: '=>';
ELLIPSIS: '...';
QQ: '??';
QEQ: '?=';
EQEQ: '==';
NEQEQ: '~==';
NEQ: '~=';
LE: '<=';
GE: '>=';

LPAREN: '(';
RPAREN: ')';
LBRACK: '[';
RBRACK: ']';
LBRACE: '{';
RBRACE: '}';
COMMA: ',';
SEMI: ';';
DOT: '.';
COLON: ':';
QUESTION: '?';
EQ: '=';
LT: '<';
GT: '>';
PLUS: '+';
MINUS: '-';
STAR: '*';
SLASH: '/';
CARET: '^';
AMP: '&';
PIPE: '|';
TILDE: '~';

// Keyword-symbol: a name immediately followed by ':' (e.g. x:, init-keyword:)
KEYWORD_SYM: NAME_CHARS ':';

// Reserved words. The DRM reserves most of these only in certain syntactic
// positions, but for grammar simplicity we reserve them everywhere; no
// example program in this grammar relies on using one of these words as an
// ordinary identifier.
DEFINE: 'define';
LIBRARY: 'library';
MODULE: 'module';
USE: 'use';
EXPORT: 'export';
CREATE: 'create';
CLASS: 'class';
SLOT: 'slot';
KEYWORD: 'keyword';
REQUIRED: 'required';
INHERITED: 'inherited';
GENERIC: 'generic';
DOMAIN_KW: 'domain';
SEALED: 'sealed';
METHOD: 'method';
FUNCTION: 'function';
VARIABLE: 'variable';
CONSTANT: 'constant';
LET: 'let';
HANDLER: 'handler';
LOCAL: 'local';
IF: 'if';
ELSEIF: 'elseif';
ELSE: 'else';
END: 'end';
UNLESS: 'unless';
WHILE: 'while';
UNTIL: 'until';
FOR: 'for';
FINALLY: 'finally';
IN: 'in';
THEN: 'then';
FROM: 'from';
TO: 'to';
BELOW: 'below';
ABOVE: 'above';
BY: 'by';
CASE: 'case';
OTHERWISE: 'otherwise';
SELECT: 'select';
BLOCK: 'block';
AFTERWARDS: 'afterwards';
CLEANUP: 'cleanup';
EXCEPTION: 'exception';
BEGIN: 'begin';
ALL: 'all';

NAME: NAME_START NAME_CHAR*
    | ESCAPED_NAME
    ;

fragment ESCAPED_NAME: '\\' (NAME_START NAME_CHAR* | .);

fragment NAME_CHARS: NAME_START NAME_CHAR*;
fragment ALPHA: [a-zA-Z];
fragment GRAPHIC: [!&*<>|^$%@_];
fragment NAME_START: ALPHA | GRAPHIC;
fragment NAME_CHAR: ALPHA | DIGIT | GRAPHIC | [-+~?/=];
