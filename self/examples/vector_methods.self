"A vector-like object demonstrating unary and binary method slots."
( | parent* = traits clonable.
    x <- 0.
    y <- 0.

    length = ( (x * x + (y * y)) sqrt ).

    + arg = ( (clone x: x + arg x) y: y + arg y ).
  |
)
