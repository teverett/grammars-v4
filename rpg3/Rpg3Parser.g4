parser grammar Rpg3Parser;
options { tokenVocab = Rpg3Lexer; }

program
    : blankOrSpecLine* EOF
    ;

blankOrSpecLine
    : specLine? NEWLINE
    ;

specLine
    : headerSpec
    | fileSpec
    | inputSpec
    | calcSpec
    | outputSpec
    ;

headerSpec
    : H_SPEC (attrWord | STRING_LIT)*
    ;

fileSpec
    : F_SPEC attrWord attrWord*
    ;

inputSpec
    : I_SPEC attrWord (INT_LIT MINUS INT_LIT (COMMA INT_LIT)?)?
    ;

// A single-letter spec-type keyword (H/F/I/C/O) reads, out of context, the
// same as a one-character RPG attribute/designation code (e.g. the file
// type/designation letters used in a file-description specification), so
// attribute positions accept the spec-type tokens as plain words too.
attrWord
    : IDENTIFIER
    | INT_LIT
    | H_SPEC
    | F_SPEC
    | I_SPEC
    | C_SPEC
    | O_SPEC
    ;

calcSpec
    : C_SPEC indicatorGroup? operand? opcode operand? operand? indicatorGroup?
    ;

indicatorGroup
    : LPAREN operand (COMMA operand)* RPAREN
    ;

opcode
    : ADD | SUB | MULT | DIV | MOVE | MOVEL | ZADD | ZSUB | COMP
    | IFEQ | IFGT | IFLT | IFGE | IFLE | IFNE | ELSE | ENDIF
    | DO | ENDDO | GOTO | TAG | EXCPT | CALL | PARM | CHAIN
    | READ | WRITE | UPDATE | DELETE | SETON | SETOF | RETRN
    | EXSR | BEGSR | ENDSR | ENDOP
    ;

operand
    : attrWord
    | STRING_LIT
    ;

outputSpec
    : O_SPEC attrWord outputField*
    ;

outputField
    : attrWord
    | STRING_LIT
    ;
