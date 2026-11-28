parser grammar CplParser;

options { tokenVocab = CplLexer; }

program
    : sectionBody? EOF
    ;

sectionBody
    : item (SEMI? item)* SEMI?
    ;

item
    : declaration
    | command
    ;

block
    : (SECTION_OPEN sectionBody? SECTION_CLOSE)
    | (LBRACE sectionBody? RBRACE)
    ;

// ---------- Declarations ----------

declaration
    : LET REC? binding (AND binding)* (IN item)?
    ;

binding
    : functionDef
    | nameList EQ exprList
    | nameList REFDEF exprList
    | name SUBSTDEF expr
    ;

functionDef
    : funcName callArgs EQ funcBody
    ;

// CPL's own account says function calls and array subscripts both used
// square brackets; the one concrete CPL-flavored source text available
// (and the Wikipedia MAX example) instead shows parentheses. Both are
// accepted here. See README.md Notes.
callArgs
    : LPAREN paramList? RPAREN
    | LBRACK paramList? RBRACK
    ;

funcBody
    : expr
    | VALUE OF block
    ;

paramList
    : name (COMMA name)*
    ;

nameList
    : name (COMMA name)*
    ;

name
    : IDENTIFIER
    ;

funcName
    : IDENTIFIER
    ;

// ---------- Commands ----------

command
    : assignment
    | ifCommand
    | testCommand
    | whileCommand
    | untilCommand
    | repeatCommand
    | forCommand
    | resultIsCommand
    | block
    | exprCommand
    ;

qualifiedCommand
    : command (WHERE binding (AND binding)*)?
    ;

assignment
    : lvalueList ASSIGN exprList
    ;

lvalueList
    : lvalue (COMMA lvalue)*
    ;

lvalue
    : name indexSuffix*
    | BANG expr
    ;

indexSuffix
    : LBRACK expr RBRACK
    | BANG expr
    ;

ifCommand
    : IF expr THEN qualifiedCommand (ELSE qualifiedCommand)?
    ;

testCommand
    : TEST expr THEN qualifiedCommand OR qualifiedCommand
    ;

whileCommand
    : WHILE expr DO qualifiedCommand
    ;

untilCommand
    : UNTIL expr DO qualifiedCommand
    ;

repeatCommand
    : REPEAT qualifiedCommand WHILE expr
    | REPEAT qualifiedCommand UNTIL expr
    | REPEAT qualifiedCommand
    ;

forCommand
    : FOR name EQ expr TO expr (BY expr)? DO qualifiedCommand
    ;

resultIsCommand
    : RESULT IS expr
    ;

exprCommand
    : expr
    ;

// ---------- Expressions ----------

expr
    : condExpr (WHERE binding (AND binding)*)?
    ;

condExpr
    : orExpr (ARROW orExpr COMMA orExpr)?
    ;

orExpr
    : andExpr (OR andExpr)*
    ;

andExpr
    : relExpr (AND relExpr)*
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
    : (PLUS | MINUS | BANG | AT | LV) unaryExpr
    | postfixExpr
    ;

postfixExpr
    : primaryExpr (callSuffix | subscriptSuffix)*
    ;

callSuffix
    : LPAREN exprList? RPAREN
    | LBRACK exprList? RBRACK
    ;

subscriptSuffix
    : BANG primaryExpr
    ;

primaryExpr
    : NUMBER
    | STRING
    | IDENTIFIER
    | VALUE OF block
    | LPAREN expr RPAREN
    ;

exprList
    : expr (COMMA expr)*
    ;
