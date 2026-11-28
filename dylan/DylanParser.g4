parser grammar DylanParser;

options { tokenVocab = DylanLexer; }

program
    : topLevelForm* EOF
    ;

topLevelForm
    : definition
    | moduleHeader
    ;

// A `module: name` / `library: name` style header line, as sometimes found
// atop a .dylan source file.
moduleHeader
    : NAME COLON NAME SEMI
    ;

definition
    : defineLibrary
    | defineModule
    | defineClass
    | defineGeneric
    | defineMethod
    | defineFunction
    | defineVariable
    | defineConstant
    | defineDomain
    ;

defineLibrary
    : DEFINE NAME? LIBRARY name=NAME
        libraryClause*
      END LIBRARY? NAME? SEMI
    ;

libraryClause
    : USE NAME useOption* SEMI
    | EXPORT nameList SEMI
    ;

defineModule
    : DEFINE MODULE name=NAME
        moduleClause*
      END MODULE? NAME? SEMI
    ;

moduleClause
    : USE NAME useOption* SEMI
    | EXPORT nameList SEMI
    | CREATE nameList SEMI
    ;

useOption
    : COMMA KEYWORD_SYM useOptionValue
    ;

useOptionValue
    : ALL
    | NAME
    | LBRACE renameList? RBRACE
    | STRING
    ;

renameList
    : renameItem (COMMA renameItem)*
    ;

renameItem
    : NAME (ARROW NAME)?
    ;

nameList
    : NAME (COMMA NAME)*
    ;

defineClass
    : DEFINE adjective* CLASS name=NAME LPAREN superclassList? RPAREN
        classItem*
      END CLASS? NAME? SEMI
    ;

superclassList
    : NAME (COMMA NAME)*
    ;

classItem
    : slotSpec SEMI
    | keywordSpec SEMI
    | inheritedSpec SEMI
    ;

slotSpec
    : adjective* SLOT getter=NAME typeSpec? (EQ expression)? classItemOption*
    ;

keywordSpec
    : REQUIRED? KEYWORD classItemKey (EQ expression)? classItemOption*
    ;

classItemKey
    : KEYWORD_SYM
    | UNIQUE_STRING
    ;

inheritedSpec
    : INHERITED SLOT getter=NAME (EQ expression)? classItemOption*
    ;

classItemOption
    : COMMA KEYWORD_SYM expression
    ;

defineGeneric
    : DEFINE adjective* GENERIC name=operatorName LPAREN parameterList? RPAREN returnValues? (COMMA genericOption)* SEMI
    ;

genericOption
    : KEYWORD_SYM expression
    ;

argTypeList
    : NAME (COMMA NAME)*
    ;

defineDomain
    : DEFINE adjective* DOMAIN_KW name=operatorName LPAREN argTypeList? RPAREN SEMI
    ;

defineMethod
    : DEFINE adjective* METHOD name=operatorName LPAREN parameterList? RPAREN returnValues?
        body
      END METHOD? operatorName? SEMI
    ;

defineFunction
    : DEFINE adjective* FUNCTION name=operatorName LPAREN parameterList? RPAREN returnValues?
        body
      END FUNCTION? operatorName? SEMI
    ;

operatorName
    : NAME
    | binaryOperatorToken
    ;

defineVariable
    : DEFINE adjective* VARIABLE variableSpec (COMMA variableSpec)* EQ expression SEMI
    ;

defineConstant
    : DEFINE adjective* CONSTANT variableSpec (COMMA variableSpec)* EQ expression SEMI
    ;

variableSpec
    : NAME typeSpec?
    | HASH_REST NAME typeSpec?
    ;

adjective
    : NAME
    | SEALED
    | CONSTANT
    ;

parameterList
    : parameter (COMMA parameter)*
    ;

parameter
    : HASH_KEY
    | HASH_NEXT NAME
    | HASH_REST NAME
    | HASH_ALL_KEYS
    | KEYWORD_SYM NAME (EQ expression)?
    | NAME (EQ expression)?
    | NAME typeSpec
    | NAME EQEQ expression
    ;

returnValues
    : ARROW LPAREN returnValueList? RPAREN
    | ARROW returnValueItem
    ;

returnValueList
    : returnValueItem (COMMA returnValueItem)*
    ;

returnValueItem
    : HASH_REST NAME
    | NAME typeSpec?
    ;

typeSpec
    : COLONCOLON type_
    ;

type_
    : NAME
    ;

// ---------- Bodies / statements ----------

body
    : constituent (SEMI constituent)* SEMI?
    | /* empty */
    ;

constituent
    : letStatement
    | localStatement
    | statement
    | expression
    ;

letStatement
    : LET HANDLER type_ EQ expression
    | LET LPAREN letBindingList RPAREN typeSpec? EQ expression
    | LET NAME typeSpec? EQ expression
    ;

letBindingList
    : letBindingItem (COMMA letBindingItem)*
    ;

letBindingItem
    : HASH_REST NAME
    | NAME typeSpec?
    ;

localStatement
    : LOCAL localMethod (COMMA localMethod)*
    ;

localMethod
    : METHOD name=operatorName LPAREN parameterList? RPAREN returnValues?
        body
      END METHOD?
    ;

statement
    : ifStatement
    | unlessStatement
    | whileStatement
    | untilStatement
    | forStatement
    | caseStatement
    | selectStatement
    | blockStatement
    | beginStatement
    ;

ifStatement
    : IF LPAREN expression RPAREN
        body
      (ELSEIF LPAREN expression RPAREN body)*
      (ELSE body)?
      END IF?
    ;

unlessStatement
    : UNLESS LPAREN expression RPAREN
        body
      END UNLESS?
    ;

whileStatement
    : WHILE LPAREN expression RPAREN
        body
      END WHILE?
    ;

untilStatement
    : UNTIL LPAREN expression RPAREN
        body
      END UNTIL?
    ;

forStatement
    : FOR LPAREN forClause (COMMA forClause)* RPAREN
        body
      (FINALLY body)?
      END FOR?
    ;

forClause
    : NAME typeSpec? IN expression
    | NAME typeSpec? EQ expression THEN expression
    | NAME typeSpec? FROM expression forBound? (BY expression)?
    | KEYWORD_SYM expression
    ;

forBound
    : TO expression
    | BELOW expression
    | ABOVE expression
    ;

caseStatement
    : CASE
        caseClause*
      END CASE?
    ;

caseClause
    : OTHERWISE ARROW body
    | expression ARROW body
    ;

selectStatement
    : SELECT LPAREN expression (BY expression)? RPAREN
        selectClause*
      END SELECT?
    ;

selectClause
    : OTHERWISE ARROW body
    | expression (COMMA expression)* ARROW body
    ;

blockStatement
    : BLOCK LPAREN NAME? RPAREN
        body
      (AFTERWARDS body)?
      (CLEANUP body)?
      (EXCEPTION LPAREN NAME typeSpec? RPAREN body)*
      END BLOCK?
    ;

beginStatement
    : BEGIN
        body
      END BEGIN?
    ;

// ---------- Expressions ----------

expression
    : assignExpr
    ;

assignExpr
    : orExpr (COLONEQ assignExpr)?
    ;

orExpr
    : andExpr (PIPE andExpr)*
    ;

andExpr
    : compareExpr (AMP compareExpr)*
    ;

compareExpr
    : addExpr (compareOp addExpr)*
    ;

compareOp
    : EQ | EQEQ | NEQ | NEQEQ | LT | LE | GT | GE
    ;

addExpr
    : mulExpr ((PLUS | MINUS) mulExpr)*
    ;

mulExpr
    : powExpr ((STAR | SLASH) powExpr)*
    ;

powExpr
    : unaryExpr (CARET powExpr)?
    ;

unaryExpr
    : (MINUS | TILDE) unaryExpr
    | postfixExpr
    ;

postfixExpr
    : primaryExpr postfixOp*
    ;

postfixOp
    : LPAREN argumentList? RPAREN
    | LBRACK expression (COMMA expression)* RBRACK
    | DOT NAME
    ;

argumentList
    : argument (COMMA argument)*
    ;

argument
    : KEYWORD_SYM expression
    | expression
    ;

primaryExpr
    : literal
    | NAME
    | binaryOperatorToken
    | LPAREN expression RPAREN
    | statement
    ;

binaryOperatorToken
    : PLUS | MINUS | STAR | SLASH | CARET | EQ | EQEQ | NEQ | NEQEQ
    | LT | LE | GT | GE | AMP | PIPE | COLONEQ
    ;

literal
    : NUMBER
    | STRING
    | CHAR_LITERAL
    | UNIQUE_STRING
    | KEYWORD_SYM
    | HASH_T
    | HASH_F
    | listLiteral
    | vectorLiteral
    ;

listLiteral
    : HASH_PAREN (expression (COMMA expression)* (DOT expression)?)? RPAREN
    ;

vectorLiteral
    : HASH_BRACKET (expression (COMMA expression)*)? RBRACK
    ;
