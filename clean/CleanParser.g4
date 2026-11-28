parser grammar CleanParser;

options { tokenVocab = CleanLexer; }

// This grammar covers Clean's "layout-off" surface syntax (Language Report
// section 2.3.3): every definition is explicitly terminated with ';' and
// explicit '{' '}' group alternatives, rather than relying on the offside
// (indentation) layout rule that Clean normally lets a module omit. See
// README.md Notes for why.

program
    : module_ EOF
    ;

module_
    : moduleHeader definition*
    ;

moduleHeader
    : (IMPLEMENTATION | DEFINITION | SYSTEM)? MODULE moduleName SEMI
    ;

moduleName
    : UPPER_ID (DOT UPPER_ID)*
    | LOWER_ID
    ;

definition
    : importDecl
    | fixityDecl
    | typeDef
    | classDef
    | instanceDef
    | genericDef
    | funcTypeSig
    | funcDef
    ;

// ---------- Imports ----------

importDecl
    : IMPORT importedModule (COMMA importedModule)* SEMI
    | FROM moduleName IMPORT importedName (COMMA importedName)* SEMI
    ;

importedModule
    : moduleName
    ;

importedName
    : LOWER_ID
    | UPPER_ID
    | DCOLON UPPER_ID (LPAREN (DOTDOT | nameList)? RPAREN)?
    | DCOLON UPPER_ID LBRACE (DOTDOT | nameList)? RBRACE
    | CLASS UPPER_ID (LPAREN DOTDOT RPAREN)?
    | INSTANCE UPPER_ID typeAtom+
    ;

nameList
    : idName (COMMA idName)*
    ;

idName
    : LOWER_ID
    | UPPER_ID
    ;

// ---------- Fixity declarations ----------

fixityDecl
    : (INFIXL | INFIXR | INFIX) INT_LIT? opNameList SEMI
    ;

opNameList
    : LPAREN opName RPAREN (COMMA LPAREN opName RPAREN)*
    ;

opName
    : FUNNY_ID
    | LOWER_ID
    | COLON
    ;

// ---------- Type definitions ----------

typeDef
    : DCOLON typeLhs EQUALS (typeRhs | LBRACE recordFieldList RBRACE) SEMI
    | DCOLON typeLhs TYPESYN typeExpr SEMI
    | DCOLON typeLhs SEMI
    ;

typeLhs
    : LPAREN opName RPAREN typeVar*
    | UPPER_ID typeVar*
    ;

typeVar
    : LOWER_ID
    ;

typeRhs
    : conDef (PIPE conDef)*
    ;

conDef
    : UPPER_ID conArgType*
    | LPAREN opName RPAREN conArgType conArgType
    ;

conArgType
    : BANG? typeAtom
    ;

recordFieldList
    : recordField (COMMA recordField)*
    ;

recordField
    : idName DCOLON BANG? typeExpr
    ;

// ---------- Classes / instances / generics (minimal) ----------

classDef
    : CLASS UPPER_ID typeVar+ (PIPE classContext)? SEMI
    | CLASS UPPER_ID typeVar+ (PIPE classContext)? classBody SEMI
    ;

classBody
    : LBRACE classMember* RBRACE
    | WHERE LBRACE classMember* RBRACE
    ;

classMember
    : funcTypeSig
    ;

instanceDef
    : INSTANCE UPPER_ID typeAtom+ SEMI
    | INSTANCE UPPER_ID typeAtom+ instanceBody SEMI
    ;

instanceBody
    : LBRACE localDef* RBRACE
    | WHERE LBRACE localDef* RBRACE
    ;

genericDef
    : GENERIC LOWER_ID DCOLON typeExpr SEMI
    ;

// ---------- Type expressions ----------

typeExpr
    : typeArrow (PIPE classContext)?
    ;

typeArrow
    : typeApp (ARROW typeArrow)?
    ;

typeApp
    : uniqAttr? typeAtom+
    ;

uniqAttr
    : STAR
    | DOT
    ;

classContext
    : classConstraint (AMP classConstraint)*
    ;

classConstraint
    : UPPER_ID typeVar+
    ;

typeAtom
    : BANG? uniqAttr? typeAtomBase
    ;

typeAtomBase
    : UPPER_ID
    | LOWER_ID
    | LPAREN typeExpr (COMMA typeExpr)* RPAREN
    | LBRACK typeExpr? RBRACK
    | STRICTLISTOPEN typeExpr RBRACK
    | UNBOXLISTOPEN typeExpr (BANG)? RBRACK
    | OVERLOADLISTOPEN typeExpr RBRACK
    | LBRACE typeExpr? RBRACE
    | LBRACE BANG typeExpr RBRACE
    | LBRACE HASH typeExpr RBRACE
    ;

// ---------- Function type signatures ----------

funcTypeSig
    : funcNameFix (COMMA funcNameFix)* DCOLON typeSigBody SEMI
    ;

funcNameFix
    : funcName ((INFIXL | INFIXR | INFIX) INT_LIT?)?
    ;

typeSigBody
    : argType* ARROW resultType (PIPE classContext)?
    | argType* ARROW resultType
    | typeExpr
    ;

argType
    : typeAtom
    ;

resultType
    : typeApp
    ;

funcName
    : LOWER_ID
    | START
    | LPAREN opName RPAREN
    ;

// ---------- Function definitions ----------

funcDef
    : funcLhs rhsAlt+ localDefs? SEMI
    ;

funcLhs
    : funcName pattern*
    | pattern FUNNY_ID pattern
    | pattern COLON pattern
    ;

rhsAlt
    : guardedRhs+
    | EQUALS expr
    ;

guardedRhs
    : PIPE (OTHERWISE | expr) EQUALS expr
    ;

localDefs
    : WHERE LBRACE localDef* RBRACE
    | WITH LBRACE localDef* RBRACE
    ;

localDef
    : funcTypeSig
    | funcDef
    ;

// ---------- Patterns ----------

pattern
    : patternAtom (COLON patternAtom)*
    | LOWER_ID BINDEQ pattern
    ;

patternAtom
    : LOWER_ID
    | UPPER_ID patternAtom*
    | literal
    | LPAREN pattern (COMMA pattern)* RPAREN
    | LBRACK (pattern (COMMA pattern)* (COLON pattern)?)? RBRACK
    | LBRACE recordPatternField (COMMA recordPatternField)* RBRACE
    | LBRACE UPPER_ID PIPE recordPatternField (COMMA recordPatternField)* RBRACE
    | UNDERSCORE
    ;

recordPatternField
    : idName (EQUALS pattern)?
    ;

// ---------- Expressions ----------

expr
    : letExpr
    | letBeforeExpr
    | caseExpr
    | ifExpr
    | lambdaExpr
    | opExpr
    ;

letExpr
    : LET LBRACE localDef* RBRACE IN expr
    ;

letBeforeExpr
    : (HASH | FORCEBIND) letBeforeBinding (COMMA letBeforeBinding)* SEMI expr
    ;

letBeforeBinding
    : pattern EQUALS expr
    ;

caseExpr
    : CASE expr OF LBRACE caseAlt* RBRACE
    ;

caseAlt
    : pattern (caseGuardedRhs+ | EQUALS expr) SEMI
    ;

caseGuardedRhs
    : PIPE (OTHERWISE | expr) EQUALS expr
    ;

ifExpr
    : IF LPAREN expr RPAREN expr expr
    ;

lambdaExpr
    : BACKSLASH pattern+ (ARROW | EQUALS) expr
    ;

opExpr
    : appExpr (operator appExpr)*
    ;

operator
    : FUNNY_ID
    | COLON
    | BANG
    | STAR
    | PIPE
    | AMP
    | UNIQLE
    | LOWER_ID
    ;

appExpr
    : unaryExpr+
    ;

unaryExpr
    : STAR? atomExpr selectorSuffix*
    ;

selectorSuffix
    : DOT LOWER_ID
    | DOT LBRACK expr (COMMA expr)* RBRACK
    | BANG LBRACK expr RBRACK
    ;

atomExpr
    : literal
    | LOWER_ID
    | UPPER_ID
    | LPAREN RPAREN
    | LPAREN opName RPAREN
    | LPAREN expr (COMMA expr)* RPAREN
    | listExpr
    | arrayExpr
    | recordExpr
    | UNDERSCORE
    ;

listExpr
    : LBRACK listBody? RBRACK
    | STRICTLISTOPEN listBody? RBRACK
    | UNBOXLISTOPEN listBody? RBRACK
    | OVERLOADLISTOPEN listBody? RBRACK
    ;

listBody
    : expr (COMMA expr)* (DOTDOT expr?)?
    | expr COLON expr
    | comprehension
    ;

comprehension
    : expr COMPSEP qualifier (COMMA qualifier)* (AMP qualifier)*
    ;

qualifier
    : pattern (LISTCOMPGEN | ARRCOMPGEN) expr
    | LET LBRACE localDef* RBRACE
    | PIPE expr
    ;

arrayExpr
    : LBRACE arrayBody? RBRACE
    ;

arrayBody
    : expr (COMMA expr)*
    | comprehension
    | arrayUpdateBody
    ;

arrayUpdateBody
    : atomExpr AMP arrayUpdateItem (COMMA arrayUpdateItem)*
    ;

arrayUpdateItem
    : LBRACK expr (COMMA expr)* RBRACK EQUALS expr
    | idName EQUALS expr
    ;

recordExpr
    : LBRACE (UPPER_ID PIPE)? recordUpdateBase? recordFieldInit (COMMA recordFieldInit)* RBRACE
    ;

recordUpdateBase
    : atomExpr AMP
    ;

recordFieldInit
    : idName EQUALS expr
    ;

literal
    : INT_LIT
    | REAL_LIT
    | CHAR_LIT
    | STRING_LIT
    | BOOL_LIT
    ;
