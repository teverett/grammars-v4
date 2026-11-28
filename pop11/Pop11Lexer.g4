lexer grammar Pop11Lexer;

// POP-11 is the successor to POP-2, developed from the early 1980s as the
// core language of the "Poplog" AI programming environment (University of
// Sussex / University of Edinburgh). It keeps POP-2's reversed assignment
// operator ("<expression> -> <variable>;") but replaces POP-2's bare
// "function ... end" and "if ... close" with explicit, keyword-specific
// closers ("define ... enddefine", "if ... endif", "for ... endfor", ...),
// and adds real while/repeat loops that POP-2 never had.
//
// This grammar is grounded in verified primary/secondary sources: the
// Wikipedia POP-11 article (which supplies the "define"/"enddefine",
// "->", "for ... in ... do ... endfor", and "unless ... endunless" forms,
// quoted directly from its own example) and an archived Poplog teaching
// file (which supplies the ";;;" comment convention, the "[...]" list
// literal with "^" splice, and the "==>" print operator). See README.md
// for exactly which constructs come from which source, and which
// (e.g. "while"/"repeat" loops, "if"/"endif" itself) are plausible,
// pattern-consistent extensions that were NOT independently confirmed
// against a primary source.

DEFINE: 'define';
ENDDEFINE: 'enddefine';
PROCEDURE: 'procedure';
ENDPROCEDURE: 'endprocedure';
VARS: 'vars';
LVARS: 'lvars';
IF: 'if';
THEN: 'then';
ELSEIF: 'elseif';
ELSE: 'else';
ENDIF: 'endif';
UNLESS: 'unless';
ENDUNLESS: 'endunless';
WHILE: 'while';
DO: 'do';
ENDWHILE: 'endwhile';
FOR: 'for';
IN: 'in';
ENDFOR: 'endfor';
REPEAT: 'repeat';
UNTIL: 'until';
ENDREPEAT: 'endrepeat';
AND: 'and';
OR: 'or';
NOT: 'not';

IDENTIFIER: [A-Za-z] [A-Za-z0-9_]*;

INT_LIT: '8:' OCTALDIGIT+ | '2:' BINARYDIGIT+ | DIGIT+;
fragment OCTALDIGIT: [0-7];
fragment BINARYDIGIT: [01];
fragment DIGIT: [0-9];

REAL_LIT: DIGIT* '.' DIGIT+ ('10' [+-] DIGIT+)?;

WORD_LIT: '"' (~["\r\n])* '"';
STRING_LIT: '\'' (~['\r\n])* '\'';

ARROW: '->';
PRINTARROW: '==>';
LE: '<=';
GE: '>=';
EQ: '=';
LT: '<';
GT: '>';
PLUS: '+';
MINUS: '-';
STAR: '*';
SLASH: '/';
CARET: '^';
LPAREN: '(';
RPAREN: ')';
LBRACK: '[';
RBRACK: ']';
COMMA: ',';
SEMI: ';';

// ";;; ... " comments run to end of line (confirmed from an archived
// Poplog teaching file, e.g. "lib river; ;;; this loads the river
// library"). POP-11 is also widely documented elsewhere as supporting
// "/* ... */" block comments, but that was not independently confirmed
// against a primary source reached while researching this grammar, so it
// is not modeled here.
LINE_COMMENT: ';;;' ~[\r\n]* -> skip;

WS: [ \t\r\n\f]+ -> skip;
