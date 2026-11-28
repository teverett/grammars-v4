parser grammar MadParser;

options { tokenVocab = MadLexer; }

program
    : NEWLINE* line* EOF
    ;

line
    : IDENTIFIER? statement? NEWLINE+
    ;

statement
    : assignmentStmt
    | wheneverBlockStmt
    | wheneverOneLineStmt
    | throughStmt
    | transferStmt
    | continueStmt
    | declStmt
    | vectorValuesStmt
    | printStmt
    | readStmt
    | functionDefStmt
    | functionReturnStmt
    | entryToStmt
    | executeStmt
    | normalModeStmt
    | endOfProgramStmt
    ;

assignmentStmt
    : IDENTIFIER subscript? EQUALS expr
    ;

subscript
    : LPAREN expr (COMMA expr)* RPAREN
    ;

// One-line form: `WHENEVER cond, stmt`
wheneverOneLineStmt
    : WHENEVER expr COMMA statement
    ;

// Block form, closed with `END OF CONDITIONAL`.
wheneverBlockStmt
    : WHENEVER expr NEWLINE+ line*
      (OR WHENEVER expr NEWLINE+ line*)*
      (OTHERWISE NEWLINE+ line*)?
      END OF CONDITIONAL
    ;

throughStmt
    : THROUGH IDENTIFIER COMMA FOR VALUES OF IDENTIFIER EQUALS expr COMMA expr COMMA expr
    ;

transferStmt
    : TRANSFER TO IDENTIFIER
    ;

continueStmt
    : CONTINUE
    ;

declStmt
    : INTEGER identList
    | FLOATING POINT identList
    | BOOLEAN identList
    | FUNCTION NAME identList
    | STATEMENT LABEL identList
    | MODE NUMBER_KW NUMBER COMMA identList
    | DIMENSION dimItem (COMMA dimItem)*
    ;

identList
    : identItem (COMMA identItem)*
    ;

identItem
    : IDENTIFIER (LPAREN expr (COMMA expr)* RPAREN)?
    ;

dimItem
    : IDENTIFIER LPAREN dimBound (COMMA dimBound)* RPAREN
    ;

dimBound
    : expr (DOT DOT DOT expr)?
    ;

vectorValuesStmt
    : VECTOR VALUES IDENTIFIER subscript? (DOT DOT DOT IDENTIFIER subscript?)? EQUALS expr (COMMA expr)*
    ;

printStmt
    : PRINT FORMAT IDENTIFIER (COMMA identList)?
    | PRINT COMMENT STRING
    | PRINT RESULTS identList
    ;

readStmt
    : READ DATA readItem (COMMA readItem)*
    | READ FORMAT IDENTIFIER COMMA identList
    ;

readItem
    : IDENTIFIER EQUALS expr
    ;

functionDefStmt
    : INTERNAL FUNCTION IDENTIFIER DOT LPAREN identList? RPAREN EQUALS expr
    | INTERNAL FUNCTION IDENTIFIER DOT LPAREN identList? RPAREN NEWLINE+ line* END OF FUNCTION
    | EXTERNAL FUNCTION IDENTIFIER DOT LPAREN identList? RPAREN
    ;

functionReturnStmt
    : FUNCTION RETURN expr?
    ;

entryToStmt
    : ENTRY TO NAME IDENTIFIER DOT
    ;

executeStmt
    : EXECUTE IDENTIFIER DOT LPAREN expr? (COMMA expr)* RPAREN
    ;

normalModeStmt
    : NORMAL MODE IS (INTEGER | BOOLEAN | FLOATING POINT | STATEMENT LABEL | FUNCTION NAME | MODE NUMBER_KW NUMBER)
    ;

endOfProgramStmt
    : END OF PROGRAM
    ;

// ---------- Expressions ----------

expr
    : orExpr
    ;

orExpr
    : andExpr ((DOTOR | DOTEXOR | DOTEQV | DOTTHEN) andExpr)*
    ;

andExpr
    : notExpr (DOTAND notExpr)*
    ;

notExpr
    : DOTNOT notExpr
    | relExpr
    ;

relExpr
    : addExpr ((DOTLT | DOTLE | DOTEQ | DOTNE | DOTGT | DOTGE) addExpr)?
    ;

addExpr
    : mulExpr ((PLUS | MINUS) mulExpr)*
    ;

mulExpr
    : bitExpr ((STAR | SLASH) bitExpr)*
    ;

bitExpr
    : powExpr ((DOTBAND | DOTBOR | DOTBXOR | DOTLSHIFT | DOTRSHIFT) powExpr)*
    ;

powExpr
    : unaryExpr (DOTPOW powExpr)?
    ;

unaryExpr
    : (PLUS | MINUS | DOTABS | DOTBNOT) unaryExpr
    | primary
    ;

primary
    : NUMBER
    | BOOL_LIT
    | STRING
    | functionCall
    | IDENTIFIER subscript?
    | LPAREN expr RPAREN
    ;

functionCall
    : IDENTIFIER DOT LPAREN expr? (COMMA expr)* RPAREN
    ;
