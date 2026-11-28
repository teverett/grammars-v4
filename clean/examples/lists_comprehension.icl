module lists_comprehension;

import StdEnv;

squares :: [Int];
squares = [ x * x \\ x <- [1..10] | isOdd x];

pairs :: [(Int, Int)];
pairs = [ (x, y) \\ x <- [0..3], y <- [0..2]];

zipped :: [Int] [Int] -> [(Int, Int)];
zipped xs ys = [ (x, y) \\ x <- xs & y <- ys];

countDown :: [Int];
countDown = [10, 9 .. 0];

firstTwo :: [a] -> [a];
firstTwo [x, y : _] = [x, y];
firstTwo xs = xs;
