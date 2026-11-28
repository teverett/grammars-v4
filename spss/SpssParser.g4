parser grammar SpssParser;

options { tokenVocab = SpssLexer; }

program
    : command* EOF
    ;

command
    : starComment
    | commentCommand
    | beginDataCommand
    | dataListCommand
    | variableLabelsCommand
    | valueLabelsCommand
    | missingValuesCommand
    | getFileCommand
    | saveOutfileCommand
    | computeCommand
    | ifCommand
    | doIfCommand
    | loopCommand
    | recodeCommand
    | selectIfCommand
    | executeCommand
    | genericCommand
    ;

// A command whose first token is '*' is a comment, running to the
// terminating period; this is modeled at the parser level (as a
// command-position-only alternative) rather than in the lexer, since '*'
// is also the multiplication operator and a lexer rule that only treats
// it as a comment marker at column zero would need a position-sensitive
// semantic predicate -- which does not compile portably across every
// code-generation target this grammar is generated for. See README.md
// Notes.
starComment
    : STAR .*? DOT
    ;

commentCommand
    : COMMENT_KW .*? DOT
    ;

// ---------- BEGIN DATA / END DATA ----------

beginDataCommand
    : BEGIN_KW DATA_KW DOT dataLine* END_KW DATA_KW DOT
    ;

dataLine
    : (NUMBER | STRING | IDENTIFIER | PLUS | MINUS)+
    ;

// ---------- DATA LIST ----------

dataListCommand
    : DATA_KW LIST (FREE | FIXED | LIST)? SLASH dataListVarSpec+ DOT
    ;

dataListVarSpec
    : IDENTIFIER+ (LPAREN IDENTIFIER RPAREN)?
    ;

// ---------- VARIABLE LABELS / VALUE LABELS ----------

variableLabelsCommand
    : VARIABLE LABELS variableLabelSpec (SLASH variableLabelSpec)* DOT
    ;

variableLabelSpec
    : IDENTIFIER STRING
    ;

valueLabelsCommand
    : VALUE LABELS valueLabelSpec (SLASH valueLabelSpec)* DOT
    ;

valueLabelSpec
    : IDENTIFIER+ (valueLabelPair)+
    ;

valueLabelPair
    : literal STRING
    ;

// ---------- MISSING VALUES ----------

missingValuesCommand
    : MISSING VALUES missingValuesSpec (SLASH missingValuesSpec)* DOT
    ;

missingValuesSpec
    : IDENTIFIER+ LPAREN literal (COMMA literal)* RPAREN
    ;

// ---------- GET FILE / SAVE OUTFILE ----------

getFileCommand
    : GET FILE ASSIGN STRING DOT
    ;

saveOutfileCommand
    : SAVE OUTFILE ASSIGN STRING DOT
    ;

// ---------- COMPUTE ----------

computeCommand
    : COMPUTE IDENTIFIER ASSIGN expr DOT
    ;

// ---------- IF (single-statement conditional transformation) ----------

ifCommand
    : IF LPAREN expr RPAREN IDENTIFIER ASSIGN expr DOT
    ;

// ---------- DO IF / ELSE IF / ELSE / END IF ----------

doIfCommand
    : DO IF LPAREN expr RPAREN DOT command*
      (ELSE IF LPAREN expr RPAREN DOT command*)*
      (ELSE DOT command*)?
      END_KW IF DOT
    ;

// ---------- LOOP / END LOOP ----------

loopCommand
    : LOOP (IDENTIFIER ASSIGN expr TO expr)? (LPAREN expr RPAREN)? DOT
        command*
      END_KW LOOP DOT
    ;

// ---------- RECODE ----------

recodeCommand
    : RECODE IDENTIFIER+ recodeSpec+ (INTO IDENTIFIER+)? DOT
    ;

recodeSpec
    : LPAREN recodeFrom (COMMA recodeFrom)* ASSIGN literal RPAREN
    ;

recodeFrom
    : literal (THRU literal)?
    | ALL
    ;

// ---------- SELECT IF ----------

selectIfCommand
    : SELECT IF LPAREN expr RPAREN DOT
    ;

// ---------- EXECUTE ----------

executeCommand
    : EXECUTE DOT
    ;

// ---------- Generic fallback for the rest of SPSS's large command
// vocabulary (FREQUENCIES, DESCRIPTIVES, REGRESSION, CROSSTABS, and
// hundreds of others): a command name followed by any tokens up to the
// terminating period. See README.md Notes.

genericCommand
    : IDENTIFIER .*? DOT
    ;

// ---------- Expressions ----------

expr
    : orExpr
    ;

orExpr
    : andExpr ((OR | PIPE) andExpr)*
    ;

andExpr
    : notExpr ((AND | AMP) notExpr)*
    ;

notExpr
    : NOT notExpr
    | relExpr
    ;

relExpr
    : addExpr (relOp addExpr)?
    ;

relOp
    : EQ | ASSIGN | NE | NE_OP | NE_OP2 | LT | LT_OP | LE | LE_OP | GT | GT_OP | GE | GE_OP
    ;

addExpr
    : mulExpr ((PLUS | MINUS) mulExpr)*
    ;

mulExpr
    : powExpr ((STAR | SLASH) powExpr)*
    ;

powExpr
    : unaryExpr (POW powExpr)?
    ;

unaryExpr
    : (PLUS | MINUS) unaryExpr
    | postfixExpr
    ;

postfixExpr
    : primaryExpr (LPAREN argList? RPAREN)?
    ;

argList
    : expr (COMMA expr)*
    ;

primaryExpr
    : literal
    | IDENTIFIER
    | LPAREN expr RPAREN
    ;

literal
    : NUMBER
    | STRING
    | (PLUS | MINUS) NUMBER
    ;
