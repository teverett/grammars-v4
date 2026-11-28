parser grammar MesaParser;

options { tokenVocab = MesaLexer; }

program
    : directoryModule EOF
    ;

directoryModule
    : directoryStmt? moduleHeader importsClause? exportsClause? EQ BEGIN moduleBody END IDENTIFIER? DOT
    ;

directoryStmt
    : DIRECTORY moduleRef (COMMA moduleRef)* SEMI
    ;

moduleRef
    : IDENTIFIER
    ;

moduleHeader
    : IDENTIFIER COLON (DEFINITIONS | PROGRAM)
    ;

importsClause
    : IMPORTS moduleRef (COMMA moduleRef)* SEMI
    ;

exportsClause
    : EXPORTS moduleRef (COMMA moduleRef)* SEMI
    ;

moduleBody
    : topDecl*
    ;

topDecl
    : declaration SEMI
    ;

// ---------- Declarations ----------

declaration
    : typeDecl
    | procDecl
    | signalDecl
    | varDecl
    ;

typeDecl
    : IDENTIFIER COLON TYPE EQ typeExpr
    ;

signalDecl
    : IDENTIFIER COLON (SIGNAL | ERROR) paramList?
    ;

varDecl
    : IDENTIFIER COLON typeExpr (ASSIGN expr)?
    ;

procDecl
    : IDENTIFIER COLON PROC paramList (RETURNS resultList)? (EQ procBody)?
    ;

paramList
    : LBRACK (paramDecl (COMMA paramDecl)*)? RBRACK
    ;

paramDecl
    : IDENTIFIER (COMMA IDENTIFIER)* COLON typeExpr
    ;

resultList
    : LBRACK (typeExpr (COMMA typeExpr)*)? RBRACK
    ;

procBody
    : BEGIN stmtList END
    ;

typeExpr
    : IDENTIFIER
    | RECORD LBRACK (fieldDecl (COMMA fieldDecl)*)? RBRACK
    | ARRAY LBRACK expr DOTDOT expr RBRACK OF typeExpr
    | POINTER TO typeExpr
    | PROC paramList (RETURNS resultList)?
    ;

fieldDecl
    : IDENTIFIER (COMMA IDENTIFIER)* COLON typeExpr
    ;

// ---------- Statements ----------

stmt
    : compoundStmt
    | ifStmt
    | whileStmt
    | forStmt
    | loopStmt
    | selectStmt
    | assignStmt
    | callStmt
    | returnStmt
    | signalStmt
    | errorStmt
    | exitStmt
    | continueStmt
    | localDecl
    ;

guardedStmt
    : stmt (BANG catchClause (COMMA catchClause)*)?
    ;

stmtList
    : (guardedStmt SEMI)*
    ;

catchClause
    : IDENTIFIER (COMMA IDENTIFIER)* DOUBLE_ARROW stmt
    ;

localDecl
    : declaration
    ;

compoundStmt
    : BEGIN stmtList END
    ;

ifStmt
    : IF expr THEN guardedStmt (ELSE guardedStmt)?
    ;

whileStmt
    : WHILE expr DO stmtList ENDLOOP
    ;

forStmt
    : FOR IDENTIFIER IN LBRACK expr DOTDOT expr RBRACK DO stmtList ENDLOOP
    ;

loopStmt
    : LOOP stmtList ENDLOOP
    ;

selectStmt
    : SELECT expr FROM selectClause+ (ELSE stmtList)? ENDCASE
    ;

selectClause
    : expr (COMMA expr)* DOUBLE_ARROW guardedStmt SEMI
    ;

assignStmt
    : lvalue ASSIGN expr
    ;

lvalue
    : IDENTIFIER (LBRACK expr RBRACK | DOT IDENTIFIER)*
    ;

callStmt
    : IDENTIFIER LBRACK argList? RBRACK
    ;

argList
    : expr (COMMA expr)*
    ;

returnStmt
    : RETURN (LBRACK argList? RBRACK)?
    ;

signalStmt
    : SIGNAL IDENTIFIER (LBRACK argList? RBRACK)?
    ;

errorStmt
    : ERROR IDENTIFIER (LBRACK argList? RBRACK)?
    ;

exitStmt
    : EXIT
    ;

continueStmt
    : CONTINUE
    ;

// ---------- Expressions ----------

expr
    : relExpr
    ;

relExpr
    : addExpr ((EQ | NE | LT | LE | GT | GE) addExpr)?
    ;

addExpr
    : mulExpr ((PLUS | MINUS) mulExpr)*
    ;

mulExpr
    : unaryExpr ((STAR | SLASH) unaryExpr)*
    ;

unaryExpr
    : (PLUS | MINUS) unaryExpr
    | postfixExpr
    ;

postfixExpr
    : primaryExpr (callArgs | DOT IDENTIFIER)*
    ;

callArgs
    : LBRACK argList? RBRACK
    ;

primaryExpr
    : NUMBER
    | STRING
    | IDENTIFIER
    | LPAREN expr RPAREN
    ;
