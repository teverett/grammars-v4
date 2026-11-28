parser grammar Pop11Parser;
options { tokenVocab = Pop11Lexer; }

program
    : stmtList? EOF
    ;

stmtList
    : stmt (SEMI stmt)* SEMI?
    ;

stmt
    : varsDecl
    | functionDecl
    | printStmt
    | assignment
    | expr
    ;

varsDecl
    : (VARS | LVARS) IDENTIFIER+
    ;

functionDecl
    : (DEFINE | PROCEDURE) IDENTIFIER LPAREN paramList RPAREN (ARROW IDENTIFIER)? SEMI stmtList (ENDDEFINE | ENDPROCEDURE)
    ;

paramList
    : (IDENTIFIER (COMMA IDENTIFIER)*)?
    ;

printStmt
    : expr PRINTARROW
    ;

assignment
    : expr ARROW destination
    ;

destination
    : IDENTIFIER (LPAREN exprList RPAREN)?
    ;

exprList
    : expr (COMMA expr)*
    ;

expr
    : orExpr
    ;

orExpr
    : orExpr OR andExpr
    | andExpr
    ;

andExpr
    : andExpr AND notExpr
    | notExpr
    ;

notExpr
    : NOT notExpr
    | relExpr
    ;

relExpr
    : addExpr ((EQ | LT | GT | LE | GE) addExpr)?
    ;

addExpr
    : addExpr (PLUS | MINUS) mulExpr
    | mulExpr
    ;

mulExpr
    : mulExpr (STAR | SLASH) unaryExpr
    | unaryExpr
    ;

unaryExpr
    : (PLUS | MINUS) unaryExpr
    | postfixExpr
    ;

postfixExpr
    : primary (LPAREN exprList? RPAREN)*
    ;

primary
    : LPAREN expr RPAREN
    | ifExpr
    | unlessExpr
    | whileLoop
    | forLoop
    | repeatLoop
    | functionDecl
    | listLiteral
    | IDENTIFIER
    | INT_LIT
    | REAL_LIT
    | WORD_LIT
    | STRING_LIT
    ;

ifExpr
    : IF expr THEN stmtList (ELSEIF expr THEN stmtList)* (ELSE stmtList)? ENDIF
    ;

unlessExpr
    : UNLESS expr THEN stmtList (ELSE stmtList)? ENDUNLESS
    ;

whileLoop
    : WHILE expr DO stmtList ENDWHILE
    ;

forLoop
    : FOR IDENTIFIER IN expr DO stmtList ENDFOR
    ;

repeatLoop
    : REPEAT stmtList UNTIL expr ENDREPEAT
    ;

listLiteral
    : LBRACK listElem* RBRACK
    ;

listElem
    : CARET postfixExpr
    | INT_LIT
    | REAL_LIT
    | STRING_LIT
    | IDENTIFIER
    | listLiteral
    ;
