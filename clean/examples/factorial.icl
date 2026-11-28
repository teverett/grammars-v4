module factorial;

import StdEnv;

fac :: Int -> Int;
fac 0 = 1;
fac n = n * fac (n - 1);

Start :: Int;
Start = fac 10;
