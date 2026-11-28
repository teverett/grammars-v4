parser grammar GpssParser;
options { tokenVocab = GpssLexer; }

program
    : blankOrStmtLine* EOF
    ;

blankOrStmtLine
    : stmt? NEWLINE
    ;

stmt
    : label? opcode operandList
    ;

label
    : IDENTIFIER
    ;

opcode
    : SIMULATE
    | GENERATE
    | TERMINATE
    | QUEUE
    | DEPART
    | SEIZE
    | RELEASE
    | PREEMPT
    | RETURN
    | ADVANCE
    | ENTER
    | LEAVE
    | ASSIGN
    | TRANSFER
    | TEST
    | GATE
    | PRIORITY
    | LOOP
    | MARK
    | TABULATE
    | SAVEVALUE
    | SPLIT
    | ASSEMBLE
    | START
    | END
    | STORAGE
    | FUNCTION
    | VARIABLE
    | TABLE
    ;

operandList
    : operand? (COMMA operand?)*
    ;

operand
    : expr
    ;

expr
    : addExpr
    ;

addExpr
    : addExpr (PLUS | MINUS) mulExpr
    | mulExpr
    ;

mulExpr
    : mulExpr (STAR | SLASH | AT) unaryExpr
    | unaryExpr
    ;

unaryExpr
    : (PLUS | MINUS) unaryExpr
    | primary
    ;

primary
    : LPAREN expr RPAREN
    | sna
    | INT_LIT
    | REAL_LIT
    | STRING_LIT
    ;

sna
    : IDENTIFIER (DOLLAR IDENTIFIER)?
    ;
