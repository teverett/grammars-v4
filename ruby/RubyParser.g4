parser grammar RubyParser;

options { tokenVocab = RubyLexer; }

// This grammar covers Ruby's core, well-documented syntax (see
// README.md Notes for exactly what that includes and what is out of
// scope -- heredocs, percent-literals other than %w/%i, `case/in`
// pattern matching, the flip-flop operator, and a few other advanced
// forms are deliberately not modeled).

program
    : terminator* (stmt (terminator+ stmt)*)? terminator* EOF
    ;

terminator
    : SEMI
    | NEWLINE
    ;

stmtList
    : terminator* (stmt (terminator+ stmt)*)? terminator*
    ;

stmt
    : multipleAssign
    | exprStmt (stmtModifier)?
    ;

stmtModifier
    : (KW_IF | KW_UNLESS | KW_WHILE | KW_UNTIL) exprStmt
    ;

exprStmt
    : andOrExpr
    ;

multipleAssign
    : mlhsList ASSIGN mrhsList
    ;

mlhsList
    : mlhsItem (COMMA mlhsItem)+
    ;

mlhsItem
    : STAR postfixExpr?
    | postfixExpr
    ;

mrhsList
    : rescueModExpr (COMMA rescueModExpr)*
    ;

andOrExpr
    : notExpr ((KW_AND | KW_OR) notExpr)*
    ;

notExpr
    : KW_NOT notExpr
    | definedExpr
    ;

definedExpr
    : KW_DEFINED definedExpr
    | assignExpr
    ;

assignExpr
    : rescueModExpr ((ASSIGN | PLUS_ASSIGN | MINUS_ASSIGN | STAR_ASSIGN | SLASH_ASSIGN
                      | PERCENT_ASSIGN | POW_ASSIGN | LSHIFT_ASSIGN | RSHIFT_ASSIGN
                      | AMP_ASSIGN | PIPE_ASSIGN | CARET_ASSIGN | ANDAND_ASSIGN | OROR_ASSIGN) assignExpr)?
    ;

rescueModExpr
    : ternaryExpr (KW_RESCUE ternaryExpr)?
    ;

ternaryExpr
    : rangeExpr (QUESTION rangeExpr COLON rangeExpr)?
    ;

rangeExpr
    : orOrExpr ((DOT2 | DOT3) orOrExpr?)?
    ;

orOrExpr
    : andAndExpr (OROR andAndExpr)*
    ;

andAndExpr
    : equalityExpr (ANDAND equalityExpr)*
    ;

equalityExpr
    : relExpr ((CMP | EQ | EQQ | NEQ | MATCH | NMATCH) relExpr)*
    ;

relExpr
    : bitorExpr ((GT | GEQ | LT | LEQ) bitorExpr)*
    ;

bitorExpr
    : bitandExpr ((PIPE | CARET) bitandExpr)*
    ;

bitandExpr
    : shiftExpr (AMP shiftExpr)*
    ;

shiftExpr
    : addExpr ((LSHIFT | RSHIFT) addExpr)*
    ;

addExpr
    : mulExpr ((PLUS | MINUS) mulExpr)*
    ;

mulExpr
    : unaryMinusExpr ((STAR | SLASH | PERCENT) unaryMinusExpr)*
    ;

unaryMinusExpr
    : MINUS unaryMinusExpr
    | powExpr
    ;

powExpr
    : unaryExpr (POW powExpr)?
    ;

unaryExpr
    : (BANG | TILDE | PLUS) unaryExpr
    | postfixExpr
    ;

postfixExpr
    : primary postfixPart*
    ;

postfixPart
    : (DOT | AMPDOT | COLON2) methodNamePart parenArgs? block?
    | LBRACK argList? RBRACK
    ;

parenArgs
    : LPAREN argList? RPAREN
    ;

bareArgList
    : argItem (COMMA argItem)*
    ;

argList
    : argItem (COMMA argItem)*
    ;

argItem
    : STAR expr
    | POW expr
    | AMP expr?
    | (IDENTIFIER | CONSTANT) COLON expr?
    | expr ARROW expr
    | expr
    ;

expr
    : exprStmt
    ;

block
    : LBRACE blockParams? stmtList RBRACE
    | KW_DO blockParams? stmtList KW_END
    ;

blockParams
    : PIPE paramList? (SEMI IDENTIFIER (COMMA IDENTIFIER)*)? PIPE
    ;

primary
    : literal
    | KW_SELF
    | KW_NIL
    | KW_TRUE
    | KW_FALSE
    | variableRef
    | IDENTIFIER (parenArgs | bareArgList)? block?
    | KW_YIELD parenArgs?
    | KW_SUPER (parenArgs | bareArgList)? block?
    | KW_BREAK expr?
    | KW_NEXT expr?
    | KW_REDO
    | KW_RETRY
    | KW_RETURN expr?
    | KW_RAISE (parenArgs | bareArgList)?
    | LPAREN stmtList RPAREN
    | arrayLiteral
    | hashLiteral
    | lambdaLiteral
    | ifExpr
    | unlessExpr
    | caseExpr
    | whileExpr
    | untilExpr
    | forExpr
    | beginExpr
    | defExpr
    | classExpr
    | moduleExpr
    ;

variableRef
    : CONSTANT
    | IVAR_SIGIL IDENTIFIER
    | AT_AT IDENTIFIER
    | GVAR_SIGIL IDENTIFIER
    ;

methodNamePart
    : IDENTIFIER
    | CONSTANT
    | opMethodName
    | LBRACK RBRACK ASSIGN?
    ;

opMethodName
    : PLUS | MINUS | STAR | SLASH | PERCENT | POW | AMP | CARET | RSHIFT | LSHIFT
    | EQ | NEQ | EQQ | MATCH | NMATCH | CMP | LT | LEQ | GT | GEQ | PIPE | TILDE | BANG
    ;

// ---------- Literals ----------

literal
    : INT_LIT
    | FLOAT_LIT
    | stringLiteral+
    | SYMBOL
    | REGEX_LIT
    ;

stringLiteral
    : SQ_STRING
    | dqString
    ;

dqString
    : DQ_STRING_START dqPart* DQ_STRING_END
    ;

dqPart
    : STR_TEXT
    | STR_ESCAPE
    | INTERP_BEGIN stmtList RBRACE
    ;

arrayLiteral
    : LBRACK argList? RBRACK
    ;

hashLiteral
    : LBRACE hashEntries? RBRACE
    ;

hashEntries
    : hashEntry (COMMA hashEntry)* COMMA?
    ;

hashEntry
    : expr ARROW expr
    | (IDENTIFIER | CONSTANT) COLON expr?
    | STAR STAR expr
    ;

lambdaLiteral
    : KW_LAMBDA_ARROW (LPAREN paramList? RPAREN)? (LBRACE stmtList RBRACE | KW_DO stmtList KW_END)
    ;

// ---------- Control-flow expressions ----------

ifExpr
    : KW_IF exprStmt KW_THEN? stmtList (KW_ELSIF exprStmt KW_THEN? stmtList)* (KW_ELSE stmtList)? KW_END
    ;

unlessExpr
    : KW_UNLESS exprStmt KW_THEN? stmtList (KW_ELSE stmtList)? KW_END
    ;

whileExpr
    : KW_WHILE exprStmt KW_DO? stmtList KW_END
    ;

untilExpr
    : KW_UNTIL exprStmt KW_DO? stmtList KW_END
    ;

forExpr
    : KW_FOR forVars KW_IN exprStmt KW_DO? stmtList KW_END
    ;

forVars
    : IDENTIFIER (COMMA IDENTIFIER)*
    ;

caseExpr
    : KW_CASE exprStmt? terminator* whenClause+ (KW_ELSE stmtList)? KW_END
    ;

whenClause
    : KW_WHEN expr (COMMA expr)* KW_THEN? stmtList
    ;

beginExpr
    : KW_BEGIN bodyStmt KW_END ((KW_WHILE | KW_UNTIL) exprStmt)?
    ;

bodyStmt
    : stmtList rescueClause* elseClause? ensureClause?
    ;

rescueClause
    : KW_RESCUE exceptionClassList? (ARROW IDENTIFIER)? KW_THEN? stmtList
    ;

exceptionClassList
    : constantPath (COMMA constantPath)*
    ;

constantPath
    : CONSTANT (COLON2 CONSTANT)*
    ;

elseClause
    : KW_ELSE stmtList
    ;

ensureClause
    : KW_ENSURE stmtList
    ;

// ---------- def / class / module ----------

defExpr
    : KW_DEF defTarget paramListParen? ASSIGN exprStmt
    | KW_DEF defTarget paramListParen? bodyStmt KW_END
    ;

defTarget
    : (KW_SELF DOT | IDENTIFIER DOT | CONSTANT DOT)? methodNamePart ASSIGN?
    ;

paramListParen
    : LPAREN paramList? RPAREN
    | paramList
    ;

paramList
    : param (COMMA param)*
    ;

param
    : DOT3
    | STAR IDENTIFIER?
    | POW IDENTIFIER?
    | POW KW_NIL
    | AMP IDENTIFIER?
    | IDENTIFIER COLON expr?
    | IDENTIFIER ASSIGN expr
    | IDENTIFIER
    | LPAREN destructureList RPAREN
    ;

destructureList
    : destructureItem (COMMA destructureItem)*
    ;

destructureItem
    : STAR IDENTIFIER?
    | LPAREN destructureList RPAREN
    | IDENTIFIER
    ;

classExpr
    : KW_CLASS LSHIFT exprStmt bodyStmt KW_END
    | KW_CLASS CONSTANT (LT constantPath)? bodyStmt KW_END
    ;

moduleExpr
    : KW_MODULE CONSTANT bodyStmt KW_END
    ;
