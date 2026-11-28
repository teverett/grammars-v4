parser grammar CowselParser;
options { tokenVocab = CowselLexer; }

program
    : funcDef* EOF
    ;

funcDef
    : FUNCTION IDENTIFIER LAMBDA paramList stmt*
    ;

paramList
    : IDENTIFIER*
    ;

stmt
    : conditional
    | assignment
    | repeatStmt
    | upStmt
    | exprStmt
    ;

// The one available COWSEL example shows this form introduced by
// "define" for its first clause but not for its second, so "define" is
// modeled here as an optional leading keyword rather than a strictly
// required one -- see README.md.
conditional
    : DEFINE? expr THEN stmt* END
    ;

assignment
    : expr ARROW IDENTIFIER
    ;

repeatStmt
    : REPEAT
    ;

upStmt
    : UP
    ;

exprStmt
    : expr
    ;

// A COWSEL expression is a postfix (reverse-Polish) run of terms: each
// identifier is either a value being pushed or a function being applied
// to the values already pushed. This grammar does not track arity, so
// any non-empty sequence of terms is accepted as an expression.
expr
    : term+
    ;

term
    : IDENTIFIER
    | INT_LIT
    | LIT_INT
    ;
