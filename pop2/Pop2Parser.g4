parser grammar Pop2Parser;
options { tokenVocab = Pop2Lexer; }

program
    : stmtList? EOF
    ;

stmtList
    : stmt (SEMI stmt)* SEMI?
    ;

stmt
    : varsDecl
    | functionDecl
    | labelledStmt
    | gotoStmt
    | assignment
    | expr
    ;

varsDecl
    : VARS IDENTIFIER+
    ;

functionDecl
    : (FUNCTION | LAMBDA) IDENTIFIER? paramList SEMI stmtList END
    ;

paramList
    : IDENTIFIER*
    ;

labelledStmt
    : IDENTIFIER COLON stmt
    ;

gotoStmt
    : GOTO IDENTIFIER
    | RETURN
    ;

assignment
    : expr ARROW destination (COMMA destination)*
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
    : primary (LPAREN PERCENT exprList? PERCENT RPAREN | LPAREN exprList? RPAREN)*
    ;

primary
    : LPAREN expr RPAREN
    | ifExpr
    | functionDecl
    | listConstant
    | listExpr
    | IDENTIFIER
    | INT_LIT
    | REAL_LIT
    | WORD_LIT
    ;

ifExpr
    : IF expr THEN stmtList (ELSEIF expr THEN stmtList)* (ELSE stmtList)? CLOSE
    ;

listConstant
    : LBRACK listConstElem* RBRACK
    ;

listConstElem
    : INT_LIT
    | IDENTIFIER
    | listConstant
    ;

listExpr
    : LBRACK PERCENT exprList? PERCENT RBRACK
    ;
