parser grammar Coral66Parser;

options { tokenVocab = Coral66Lexer; }

program
    : IDENTIFIER SEMI communicator* segment+ EOF
    ;

communicator
    : COMMON LPAREN decl (SEMI decl)* RPAREN SEMI
    ;

segment
    : IDENTIFIER COLON block SEMI?
    ;

block
    : BEGIN (declList SEMI)? stmtList END IDENTIFIER?
    ;

declList
    : decl (SEMI decl)*
    ;

decl
    : scalarDecl
    | arrayDecl
    | switchDecl
    | overlayDecl
    | tableDecl
    | procedureDecl
    | labelSpec
    | macroDef
    | macroDelete
    ;

labelSpec
    : LABEL idList
    ;

numberType
    : FLOATING
    | FIXED LPAREN signedInt COMMA signedInt RPAREN
    | INTEGER
    ;

scalarDecl
    : numberType idList (ASSIGN constList)?
    ;

arrayDecl
    : numberType ARRAY arrayItem (COMMA arrayItem)* (ASSIGN constList)?
    ;

arrayItem
    : IDENTIFIER (LBRACK bound (COMMA bound)* RBRACK)?
    ;

bound
    : signedInt COLON signedInt
    ;

switchDecl
    : SWITCH IDENTIFIER ASSIGN idList
    ;

overlayDecl
    : OVERLAY base WITH (scalarDecl | arrayDecl)
    ;

base
    : IDENTIFIER (LBRACK signedInt RBRACK)?
    ;

tableDecl
    : TABLE IDENTIFIER LBRACK expr COMMA expr RBRACK LBRACK elementDecl (SEMI elementDecl)* RBRACK (PRESET constList)?
    ;

elementDecl
    : IDENTIFIER (UNSIGNED | SIGNED) LPAREN signedInt COMMA signedInt RPAREN (COMMA constList)?
    ;

procedureDecl
    : answerSpec? PROCEDURE procHeading SEMI statement
    | answerSpec? RECURSIVE procHeading SEMI statement
    ;

answerSpec
    : numberType
    ;

procHeading
    : IDENTIFIER (LPAREN paramSpec (SEMI paramSpec)* RPAREN)?
    ;

paramSpec
    : specifier idList
    | TABLE IDENTIFIER
    | PROCEDURE IDENTIFIER
    ;

specifier
    : VALUE numberType
    | LOCATION numberType
    | numberType ARRAY
    | LABEL
    | SWITCH
    ;

macroDef
    : DEFINE IDENTIFIER (LPAREN idList RPAREN)? MACRO_OPEN .*? MACRO_CLOSE
    ;

macroDelete
    : DELETE IDENTIFIER
    ;

idList
    : IDENTIFIER (COMMA IDENTIFIER)*
    ;

constList
    : expr (COMMA expr)*
    ;

signedInt
    : (PLUS | MINUS)? INTEGER_LIT
    ;

// ---------- Statements ----------

stmtList
    : statement (SEMI statement)*
    ;

statement
    : label* (simpleStatement | conditionalStatement | forStatement)
    ;

label
    : IDENTIFIER COLON
    ;

simpleStatement
    : assignment
    | gotoStatement
    | procCallStmt
    | answerStatement
    | codeStatement
    | block
    |
    ;

assignment
    : variable ASSIGN expr
    ;

variable
    : wordRef
    | partWord
    ;

wordRef
    : IDENTIFIER (LBRACK index (COMMA index)? RBRACK)?
    | LBRACK index RBRACK
    ;

partWord
    : BITS LBRACK signedInt COMMA signedInt RBRACK typedPrimary
    ;

index
    : expr
    ;

gotoStatement
    : GOTO destination
    ;

destination
    : IDENTIFIER (LBRACK index RBRACK)?
    ;

procCallStmt
    : IDENTIFIER (LPAREN actualList? RPAREN)?
    ;

actualList
    : expr (COMMA expr)*
    ;

answerStatement
    : ANSWER expr
    ;

codeStatement
    : CODE BEGIN .*? END
    ;

conditionalStatement
    : IF condition THEN consequence (ELSE statement)?
    ;

consequence
    : label* simpleStatement
    ;

forStatement
    : FOR IDENTIFIER ASSIGN forList DO statement
    ;

forList
    : forElement (COMMA forElement)*
    ;

forElement
    : expr WHILE condition
    | expr STEP expr UNTIL expr
    | expr
    ;

// ---------- Conditions ----------

condition
    : subcondition (OR subcondition)*
    ;

subcondition
    : comparison (AND comparison)*
    ;

comparison
    : simpleExpr comparator simpleExpr
    ;

comparator
    : LT | LE | EQ | GE | GT | NE
    ;

// ---------- Expressions ----------

expr
    : IF condition THEN expr ELSE expr
    | simpleExpr
    | STRING
    ;

simpleExpr
    : (PLUS | MINUS)? term ((PLUS | MINUS) term)*
    ;

term
    : factor ((STAR | SLASH) factor)*
    ;

factor
    : primary (( DIFFER | UNION | MASK ) primary)*
    ;

primary
    : REAL_LIT
    | LPAREN expr RPAREN
    | typedPrimary
    ;

typedPrimary
    : LOCATION LPAREN wordRef RPAREN
    | numberType LPAREN expr RPAREN
    | OCTAL LPAREN INTEGER_LIT RPAREN
    | LITERAL LPAREN . RPAREN
    | IDENTIFIER LPAREN actualList? RPAREN
    | INTEGER_LIT
    | wordRef
    | partWord
    ;
