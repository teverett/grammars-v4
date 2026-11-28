parser grammar PilotParser;

options { tokenVocab = PilotLexer; }

program
    : NEWLINE* line* EOF
    ;

line
    : (labelLine | statement) NEWLINE+
    ;

labelLine
    : STAR IDENTIFIER
    ;

statement
    : cmdLetter flag? cond? COLON textOperand?  # textStmt
    | CMD_A flag? cond? COLON varList?          # acceptStmt
    | CMD_C flag? cond? COLON assignExpr        # computeStmt
    | CMD_D flag? cond? COLON HASHVAR LPAREN NUMBER RPAREN  # dimStmt
    | CMD_J flag? cond? COLON labelRef          # jumpStmt
    | CMD_U flag? cond? COLON labelRef          # useStmt
    | CMD_M flag? cond? COLON matchList         # matchStmt
    | CMD_E flag? cond? COLON?                  # endStmt
    ;

// T:, R:, Y:, and N: all take a free-running text operand (Y: and N:
// are shorthand for TY: and TN: respectively).
cmdLetter
    : CMD_T
    | CMD_R
    | CMD_Y
    | CMD_N
    ;

flag
    : CMD_Y
    | CMD_N
    ;

cond
    : LPAREN expr relOp expr RPAREN
    ;

relOp
    : EQ | NE | LT | LE | GT | GE
    ;

// The free text following T:/R:/Y:/N: may embed numeric/string variable
// references for interpolation; everything else is consumed generically,
// since PILOT output text is otherwise unconstrained. See README.md
// Notes.
textOperand
    : textPart+
    ;

textPart
    : DOLLARVAR
    | HASHVAR
    | ~(NEWLINE | DOLLARVAR | HASHVAR)
    ;

varList
    : variable (COMMA variable)*
    ;

variable
    : DOLLARVAR
    | HASHVAR
    ;

matchList
    : matchItem (COMMA matchItem)*
    ;

matchItem
    : DOLLARVAR
    | matchWord+
    ;

matchWord
    : WORD
    | IDENTIFIER
    | NUMBER
    ;

labelRef
    : STAR IDENTIFIER
    ;

assignExpr
    : HASHVAR EQ expr
    ;

expr
    : addExpr
    ;

addExpr
    : mulExpr ((PLUS | MINUS) mulExpr)*
    ;

mulExpr
    : powExpr ((SLASH | STAR) powExpr)*
    ;

powExpr
    : unaryExpr (STARSTAR powExpr)?
    ;

unaryExpr
    : (PLUS | MINUS) unaryExpr
    | primaryExpr
    ;

primaryExpr
    : NUMBER
    | HASHVAR
    | LPAREN expr RPAREN
    ;
