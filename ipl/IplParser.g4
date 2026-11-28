parser grammar IplParser;

options { tokenVocab = IplLexer; }

// This grammar targets the `.liplv` transcription format used by the
// jeffshrager/IPL-V archive to represent IPL-V program listings as a
// sequence of 9-field parenthesized tuples (one per IPL cell), not the
// original 1964 punched-card/cell layout. See README.md Notes.

program
    : headerRow? cellRow* EOF
    ;

// (:comments :type :name :sign :pq :symb :link :comments.1 :id)
headerRow
    : LPAREN KEYWORD+ RPAREN
    ;

// ("comment text" "type" "name" "sign" "pq" "symb" "link" "comment2" "id")
cellRow
    : LPAREN field+ RPAREN
    ;

field
    : STRING
    ;
