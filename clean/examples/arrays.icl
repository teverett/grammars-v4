module arrays;

import StdEnv;

sample :: {Int};
sample = {1, 3, 5, 7, 9};

sumArray :: {Int} -> Int;
sumArray a = sum [ e \\ e <-: a];

bump :: *{Int} Int Int -> *{Int};
bump a i v = { a & [i] = v };

getAt :: {Int} Int -> Int;
getAt a i = a.[i];
