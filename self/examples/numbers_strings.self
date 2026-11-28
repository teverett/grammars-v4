"Numeric literal forms and a string literal with escapes."
( | hex <- 16r27fe.
    pi <- 3.14159.
    big <- 1272.34e+15.
    greeting <- 'Hello,\tworld!\n'.
  |
    hex printLine.
    pi printLine.
    big printLine.
    greeting printLine
)
