parser grammar ShortCodeParser;

options { tokenVocab = ShortCodeLexer; }

// This grammar models the human-written, "substitute variables" level of
// Short Code notation -- ordinary infix mathematical expressions over
// X/Y-numbered variables -- rather than the two-digit numeric codes that
// variables and operators were then manually converted into (the actual
// form stored in UNIVAC memory). See README.md Notes for why, and for
// exactly what is and is not confirmed by the one surviving example.

program
    : NEWLINE* statement (NEWLINE+ statement)* NEWLINE* EOF
    ;

statement
    : VAR EQ expr
    | expr
    ;

expr
    : addExpr
    ;

addExpr
    : mulExpr ((PLUS | MINUS) mulExpr)*
    ;

// A factor immediately following another with no operator between them
// denotes multiplication by juxtaposition, confirmed as how Short Code
// represented multiplication ("written by juxtaposition, with no
// operator code"); an explicit '*' is also accepted, since the one
// documented example shows one at the human-notation level.
mulExpr
    : unaryExpr ((STAR | SLASH)? unaryExpr)*
    ;

unaryExpr
    : (PLUS | MINUS)? primary
    ;

primary
    : NUMBER
    | VAR
    | LPAREN expr RPAREN
    ;
