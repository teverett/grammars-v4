module case_let_where;

import StdEnv;

safeHead :: [Int] -> Int;
safeHead xs = case xs of {
    [hd : _] = hd;
    []       = abort "empty list";
};

average :: [Int] -> Real;
average xs = let { s = sum xs; } in toReal s / toReal (length xs);

primes :: [Int];
primes = sieve [2..] where {
    sieve :: [Int] -> [Int];
    sieve [p:xs] = [p : sieve [x \\ x <- xs | x mod p <> 0]];
};
