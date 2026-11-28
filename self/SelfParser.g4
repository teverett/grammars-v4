parser grammar SelfParser;

options { tokenVocab = SelfLexer; }

program
    : code? EOF
    ;

code
    : (statement DOT)* (CARET? statement) DOT?
    ;

statement
    : expression
    ;

// ---------- Expressions, by precedence: keyword < binary < unary ----------

expression
    : binaryExpr keywordMessage?
    ;

keywordMessage
    : SMALL_KEYWORD IDENTIFIER? binaryExpr (CAP_KEYWORD IDENTIFIER? binaryExpr)*
    ;

binaryExpr
    : unaryExpr (binaryOperatorName unaryExpr)*
    ;

binaryOperatorName
    : OPERATOR
    | STAR
    | CARET
    | PIPE
    ;

unaryExpr
    : primary (unarySelector)*
    ;

unarySelector
    : IDENTIFIER
    ;

primary
    : resendExpr
    | SELF
    | RESEND
    | NUMBER
    | STRING
    | IDENTIFIER
    | objectOrParen
    | block
    ;

// `resend.msg` / `ParentName.msg`: a resend send whose receiver and single
// message are fused into one primary. See README.md Notes on the
// whitespace-sensitivity this grammar cannot enforce.
resendExpr
    : (RESEND | IDENTIFIER) DOT resendSelector
    ;

resendSelector
    : IDENTIFIER
    | binaryOperatorName unaryExpr
    | SMALL_KEYWORD IDENTIFIER? binaryExpr (CAP_KEYWORD IDENTIFIER? binaryExpr)*
    ;

// A plain parenthesized grouping and an object literal share the same
// outer shape; this single rule covers both (an empty bar section and no
// code at all collapses to "()", the empty object).
objectOrParen
    : LPAREN (PIPE commentAnnotation? slotList? PIPE)? code? RPAREN
    ;

// `{} = 'comment text'`, an annotation that may appear right after the
// opening bar, before the slot list.
commentAnnotation
    : LBRACE RBRACE EQUALS STRING DOT?
    ;

block
    : LBRACK (PIPE slotList? PIPE)? code? RBRACK
    ;

slotList
    : slot (DOT slot)* DOT?
    ;

slot
    : argSlot
    | annotatedGroup
    | parentSlot
    | keywordSlot
    | binarySlot
    | dataSlot
    ;

// A categorized/commented group of slots, e.g.
// `{ 'Category: accessing' getOne = (...). }`.
annotatedGroup
    : LBRACE STRING slotList RBRACE
    ;

argSlot
    : ARG_NAME
    ;

parentSlot
    : IDENTIFIER STAR (EQUALS expression | ARROW expression)?
    ;

dataSlot
    : IDENTIFIER (EQUALS expression | ARROW expression)?
    ;

binarySlot
    : binaryOperatorName IDENTIFIER? EQUALS expression
    ;

keywordSlot
    : SMALL_KEYWORD IDENTIFIER? (CAP_KEYWORD IDENTIFIER?)* EQUALS expression
    ;
