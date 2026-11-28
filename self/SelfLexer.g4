lexer grammar SelfLexer;

LINE_COMMENT_START: '"' -> pushMode(COMMENT), skip;

WS: [ \t\r\n\f]+ -> skip;

SELF: 'self';
RESEND: 'resend';

ARROW: '<-';
EQUALS: '=';
CARET: '^';
PIPE: '|';
STAR: '*';
DOT: '.';
LPAREN: '(';
RPAREN: ')';
LBRACK: '[';
RBRACK: ']';
LBRACE: '{';
RBRACE: '}';

// Argument name, e.g. ":k"
ARG_NAME: ':' [a-z_] IDCHAR*;

// Keyword parts of a keyword message/slot.
SMALL_KEYWORD: [a-z_] IDCHAR* ':';
CAP_KEYWORD: [A-Z] IDCHAR* ':';

IDENTIFIER: [a-z_] IDCHAR*;
fragment IDCHAR: [A-Za-z0-9_];

NUMBER: DIGIT+ [rR] [0-9A-Za-z]+
      | DIGIT+ '.' DIGIT+ ([eE] [+-]? DIGIT+)?
      | DIGIT+ [eE] [+-]? DIGIT+
      | DIGIT+
      ;
fragment DIGIT: [0-9];

STRING: '\'' (STR_ESC | ~['\\])* '\'';
fragment STR_ESC
    : '\\' ([tbnfrva0\\'"?] | 'x' HEXDIGIT HEXDIGIT | 'd' DIGIT DIGIT DIGIT | 'o' OCTDIGIT OCTDIGIT OCTDIGIT)
    | '\\' '\r'? '\n'
    ;
fragment HEXDIGIT: [0-9a-fA-F];
fragment OCTDIGIT: [0-7];

// A run of operator characters. The apostrophe is deliberately excluded
// even though the handbook's op-char set includes it, since treating it as
// an operator character would make this token rule ambiguous with the
// start of a STRING literal; see README.md Notes.
OPERATOR: OPCHAR+;
fragment OPCHAR: [!@#$%^&*\-+=~/?<>,;|\\];

mode COMMENT;
COMMENT_TEXT: ~["]+ -> skip;
COMMENT_END: '"' -> popMode, skip;
