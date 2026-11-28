lexer grammar RubyLexer;

LINE_COMMENT: '#' ~[\r\n]* -> skip;
WS: [ \t]+ -> skip;
LINE_CONTINUATION: '\\' '\r'? '\n' -> skip;
NEWLINE: '\r'? '\n'+;
SEMI: ';';

// ---------- Keywords ----------
KW_DEF: 'def';
KW_END: 'end';
KW_CLASS: 'class';
KW_MODULE: 'module';
KW_IF: 'if';
KW_ELSIF: 'elsif';
KW_ELSE: 'else';
KW_UNLESS: 'unless';
KW_THEN: 'then';
KW_WHILE: 'while';
KW_UNTIL: 'until';
KW_FOR: 'for';
KW_IN: 'in';
KW_DO: 'do';
KW_CASE: 'case';
KW_WHEN: 'when';
KW_BEGIN: 'begin';
KW_RESCUE: 'rescue';
KW_ENSURE: 'ensure';
KW_RETRY: 'retry';
KW_RAISE: 'raise';
KW_RETURN: 'return';
KW_BREAK: 'break';
KW_NEXT: 'next';
KW_REDO: 'redo';
KW_YIELD: 'yield';
KW_SELF: 'self';
KW_NIL: 'nil';
KW_TRUE: 'true';
KW_FALSE: 'false';
KW_AND: 'and';
KW_OR: 'or';
KW_NOT: 'not';
KW_DEFINED: 'defined?';
KW_SUPER: 'super';
KW_LAMBDA_ARROW: '->';

// ---------- Operators / punctuation ----------
DOT3: '...';
DOT2: '..';
DOT: '.';
AMPDOT: '&.';
COLON2: '::';
ARROW: '=>';
POW_ASSIGN: '**=';
POW: '**';
LSHIFT_ASSIGN: '<<=';
RSHIFT_ASSIGN: '>>=';
LSHIFT: '<<';
RSHIFT: '>>';
CMP: '<=>';
LEQ: '<=';
GEQ: '>=';
EQQ: '===';
EQ: '==';
NEQ: '!=';
MATCH: '=~';
NMATCH: '!~';
LT: '<';
GT: '>';
ANDAND_ASSIGN: '&&=';
OROR_ASSIGN: '||=';
ANDAND: '&&';
OROR: '||';
PLUS_ASSIGN: '+=';
MINUS_ASSIGN: '-=';
STAR_ASSIGN: '*=';
SLASH_ASSIGN: '/=';
PERCENT_ASSIGN: '%=';
AMP_ASSIGN: '&=';
PIPE_ASSIGN: '|=';
CARET_ASSIGN: '^=';
PLUS: '+';
MINUS: '-';
STAR: '*';
SLASH: '/';
PERCENT: '%';
AMP: '&';
PIPE: '|';
CARET: '^';
TILDE: '~';
BANG: '!';
QUESTION: '?';
COLON: ':';
COMMA: ',';
ASSIGN: '=';
LPAREN: '(';
RPAREN: ')';
LBRACK: '[';
RBRACK: ']';
LBRACE: '{';
RBRACE: '}';

AT_AT: '@@';
IVAR_SIGIL: '@';
GVAR_SIGIL: '$';

// ---------- Numbers ----------
FLOAT_LIT: DIGITS '.' DIGITS ([eE] [+-]? DIGITS)?
         | DIGITS [eE] [+-]? DIGITS
         ;
INT_LIT: '0' [dD] DIGITS
       | '0' [xX] HEXDIGITS
       | '0' [oO]? OCTDIGITS
       | '0' [bB] BINDIGITS
       | DIGITS
       ;
fragment DIGITS: [0-9] [0-9_]*;
fragment HEXDIGITS: [0-9a-fA-F] [0-9a-fA-F_]*;
fragment OCTDIGITS: [0-7] [0-7_]*;
fragment BINDIGITS: [01] [01_]*;

// ---------- Identifiers ----------
CONSTANT: [A-Z] [A-Za-z0-9_]*;
IDENTIFIER: [a-z_] [A-Za-z0-9_]* [?!]?;

// ---------- Symbols ----------
SYMBOL: ':' [A-Za-z_] [A-Za-z0-9_]* [?!=]?
      | ':' OPERATOR_METHOD_NAME
      ;
fragment OPERATOR_METHOD_NAME
    : '+' | '-' | '*' | '/' | '%' | '**' | '==' | '!=' | '<=>' | '<' | '<='
    | '>' | '>=' | '<<' | '>>' | '&' | '|' | '^' | '~' | '!' | '[]' | '[]='
    ;
// ---------- Strings ----------
SQ_STRING: '\'' ('\\' . | ~['\\])* '\'';
DQ_STRING_START: '"' -> pushMode(STR_INTERP_D);

// ---------- Regex (simplified: no interpolation modeled) ----------
REGEX_LIT: '/' (~[/\r\n\\] | '\\' .)* '/' [a-z]*;

mode CODE_MODE;

DM_LINE_COMMENT: '#' ~[\r\n]* -> skip;
DM_WS: [ \t]+ -> skip;
DM_LINE_CONTINUATION: '\\' '\r'? '\n' -> skip;
DM_NEWLINE: '\r'? '\n'+ -> type(NEWLINE);
DM_SEMI: ';' -> type(SEMI);

DM_KW_DEF: 'def' -> type(KW_DEF);
DM_KW_END: 'end' -> type(KW_END);
DM_KW_CLASS: 'class' -> type(KW_CLASS);
DM_KW_MODULE: 'module' -> type(KW_MODULE);
DM_KW_IF: 'if' -> type(KW_IF);
DM_KW_ELSIF: 'elsif' -> type(KW_ELSIF);
DM_KW_ELSE: 'else' -> type(KW_ELSE);
DM_KW_UNLESS: 'unless' -> type(KW_UNLESS);
DM_KW_THEN: 'then' -> type(KW_THEN);
DM_KW_WHILE: 'while' -> type(KW_WHILE);
DM_KW_UNTIL: 'until' -> type(KW_UNTIL);
DM_KW_FOR: 'for' -> type(KW_FOR);
DM_KW_IN: 'in' -> type(KW_IN);
DM_KW_DO: 'do' -> type(KW_DO);
DM_KW_CASE: 'case' -> type(KW_CASE);
DM_KW_WHEN: 'when' -> type(KW_WHEN);
DM_KW_BEGIN: 'begin' -> type(KW_BEGIN);
DM_KW_RESCUE: 'rescue' -> type(KW_RESCUE);
DM_KW_ENSURE: 'ensure' -> type(KW_ENSURE);
DM_KW_RETRY: 'retry' -> type(KW_RETRY);
DM_KW_RAISE: 'raise' -> type(KW_RAISE);
DM_KW_RETURN: 'return' -> type(KW_RETURN);
DM_KW_BREAK: 'break' -> type(KW_BREAK);
DM_KW_NEXT: 'next' -> type(KW_NEXT);
DM_KW_REDO: 'redo' -> type(KW_REDO);
DM_KW_YIELD: 'yield' -> type(KW_YIELD);
DM_KW_SELF: 'self' -> type(KW_SELF);
DM_KW_NIL: 'nil' -> type(KW_NIL);
DM_KW_TRUE: 'true' -> type(KW_TRUE);
DM_KW_FALSE: 'false' -> type(KW_FALSE);
DM_KW_AND: 'and' -> type(KW_AND);
DM_KW_OR: 'or' -> type(KW_OR);
DM_KW_NOT: 'not' -> type(KW_NOT);
DM_KW_DEFINED: 'defined?' -> type(KW_DEFINED);
DM_KW_SUPER: 'super' -> type(KW_SUPER);

DM_DOT3: '...' -> type(DOT3);
DM_DOT2: '..' -> type(DOT2);
DM_DOT: '.' -> type(DOT);
DM_AMPDOT: '&.' -> type(AMPDOT);
DM_COLON2: '::' -> type(COLON2);
DM_ARROW: '=>' -> type(ARROW);
DM_LAMBDA_ARROW: '->' -> type(KW_LAMBDA_ARROW);
DM_POW_ASSIGN: '**=' -> type(POW_ASSIGN);
DM_POW: '**' -> type(POW);
DM_LSHIFT_ASSIGN: '<<=' -> type(LSHIFT_ASSIGN);
DM_RSHIFT_ASSIGN: '>>=' -> type(RSHIFT_ASSIGN);
DM_LSHIFT: '<<' -> type(LSHIFT);
DM_RSHIFT: '>>' -> type(RSHIFT);
DM_CMP: '<=>' -> type(CMP);
DM_LEQ: '<=' -> type(LEQ);
DM_GEQ: '>=' -> type(GEQ);
DM_EQQ: '===' -> type(EQQ);
DM_EQ: '==' -> type(EQ);
DM_NEQ: '!=' -> type(NEQ);
DM_MATCH: '=~' -> type(MATCH);
DM_NMATCH: '!~' -> type(NMATCH);
DM_LT: '<' -> type(LT);
DM_GT: '>' -> type(GT);
DM_ANDAND_ASSIGN: '&&=' -> type(ANDAND_ASSIGN);
DM_OROR_ASSIGN: '||=' -> type(OROR_ASSIGN);
DM_ANDAND: '&&' -> type(ANDAND);
DM_OROR: '||' -> type(OROR);
DM_PLUS_ASSIGN: '+=' -> type(PLUS_ASSIGN);
DM_MINUS_ASSIGN: '-=' -> type(MINUS_ASSIGN);
DM_STAR_ASSIGN: '*=' -> type(STAR_ASSIGN);
DM_SLASH_ASSIGN: '/=' -> type(SLASH_ASSIGN);
DM_PERCENT_ASSIGN: '%=' -> type(PERCENT_ASSIGN);
DM_AMP_ASSIGN: '&=' -> type(AMP_ASSIGN);
DM_PIPE_ASSIGN: '|=' -> type(PIPE_ASSIGN);
DM_CARET_ASSIGN: '^=' -> type(CARET_ASSIGN);
DM_PLUS: '+' -> type(PLUS);
DM_MINUS: '-' -> type(MINUS);
DM_STAR: '*' -> type(STAR);
DM_SLASH: '/' -> type(SLASH);
DM_PERCENT: '%' -> type(PERCENT);
DM_AMP: '&' -> type(AMP);
DM_PIPE: '|' -> type(PIPE);
DM_CARET: '^' -> type(CARET);
DM_TILDE: '~' -> type(TILDE);
DM_BANG: '!' -> type(BANG);
DM_QUESTION: '?' -> type(QUESTION);
DM_COLON: ':' -> type(COLON);
DM_COMMA: ',' -> type(COMMA);
DM_ASSIGN: '=' -> type(ASSIGN);
DM_LPAREN: '(' -> type(LPAREN);
DM_RPAREN: ')' -> type(RPAREN);
DM_LBRACK: '[' -> type(LBRACK);
DM_RBRACK: ']' -> type(RBRACK);
DM_LBRACE: '{' -> pushMode(CODE_MODE), type(LBRACE);
DM_RBRACE: '}' -> popMode, type(RBRACE);

DM_AT_AT: '@@' -> type(AT_AT);
DM_IVAR_SIGIL: '@' -> type(IVAR_SIGIL);
DM_GVAR_SIGIL: '$' -> type(GVAR_SIGIL);

DM_FLOAT_LIT: ( [0-9] [0-9_]* '.' [0-9] [0-9_]* ([eE] [+-]? [0-9] [0-9_]*)?
              | [0-9] [0-9_]* [eE] [+-]? [0-9] [0-9_]*
              ) -> type(FLOAT_LIT);
DM_INT_LIT: ( '0' [dD] [0-9] [0-9_]*
            | '0' [xX] [0-9a-fA-F] [0-9a-fA-F_]*
            | '0' [oO]? [0-7] [0-7_]*
            | '0' [bB] [01] [01_]*
            | [0-9] [0-9_]*
            ) -> type(INT_LIT);

DM_CONSTANT: [A-Z] [A-Za-z0-9_]* -> type(CONSTANT);
DM_IDENTIFIER: [a-z_] [A-Za-z0-9_]* [?!]? -> type(IDENTIFIER);

DM_SYMBOL: ':' [A-Za-z_] [A-Za-z0-9_]* [?!=]? -> type(SYMBOL);

DM_SQ_STRING: '\'' ('\\' . | ~['\\])* '\'' -> type(SQ_STRING);
DM_DQ_STRING_START: '"' -> pushMode(STR_INTERP_D), type(DQ_STRING_START);

DM_REGEX_LIT: '/' (~[/\r\n\\] | '\\' .)* '/' [a-z]* -> type(REGEX_LIT);

// ---------- Double-quoted-string content, with #{...} interpolation ----------
mode STR_INTERP_D;

STR_TEXT: (~["\\#] | '#' ~[{"])+;
STR_ESCAPE: '\\' .;
INTERP_BEGIN: '#{' -> pushMode(CODE_MODE);
DQ_STRING_END: '"' -> popMode;
