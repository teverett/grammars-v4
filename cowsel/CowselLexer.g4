lexer grammar CowselLexer;

// COWSEL (COntrolled Working SpacE Language) is a list-processing
// language designed by Robin Popplestone (with Rod Burstall) between
// 1964 and 1966 at the University of Edinburgh, based on a reverse-Polish
// (postfix) form of Lisp combined with ideas from CPL. COWSEL was renamed
// POP-1 in 1966 and evolved into POP-2, this repo's "pop2" grammar, and
// then POP-11, this repo's "pop11" grammar.
//
// COWSEL is essentially undocumented online: the only syntax evidence
// found while researching this grammar is a single worked example quoted
// in COWSEL's (stub) Wikipedia article, sourced from a 1966 Edinburgh
// technical report:
//
//   function member
//   lambda x y
//   comment Is x a member of list y;
//   define y atom then *0 end
//   y hd x equal then *1 end
//   y tl -> y repeat up
//
// This grammar is built entirely from that one example (which already
// confirms: "function"/"lambda" to introduce a definition, "comment ...;"
// comments, postfix/RPN expressions, "->" reversed assignment -- the same
// operator POP-2 and POP-11 inherited -- "then ... end" conditionals,
// "repeat", and "up"), generalized just enough to parse more than one
// program. See README.md for exactly what is confirmed versus inferred,
// in particular the uncertain role of "define" (it introduces the first
// conditional in the example but not the second) and of "*0"/"*1" (here
// treated as a literal-number marker).

FUNCTION: 'function';
LAMBDA: 'lambda';
DEFINE: 'define';
THEN: 'then';
END: 'end';
REPEAT: 'repeat';
UP: 'up';

// "comment Is x a member of list y;" -- the word "comment" and
// everything up to and including the next semicolon is ignored. This is
// the same convention later documented explicitly in the POP-2 Reference
// Manual, so it is modeled identically here.
COMMENT: 'comment' ~[;]* ';' -> skip;

IDENTIFIER: [A-Za-z] [A-Za-z0-9]*;
INT_LIT: DIGIT+;
LIT_INT: '*' DIGIT+;
fragment DIGIT: [0-9];

ARROW: '->';

WS: [ \t\r\n\f]+ -> skip;
