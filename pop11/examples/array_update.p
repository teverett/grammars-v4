vars a;
3 -> a(4);

define SumPair(X, Y) -> Result;
    X + Y -> Result;
enddefine;

SumPair(2, 3) -> a(5);
a(5) ==>
