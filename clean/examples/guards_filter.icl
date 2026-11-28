module guards_filter;

import StdEnv;

filter :: Int [Int] -> [Int];
filter pr [n:str]
    | n mod pr == 0 = filter pr str
    | otherwise      = [n:filter pr str];
filter pr [] = [];

classify :: Int -> String;
classify n
    | n < 0 = "negative"
    | n == 0 = "zero"
    | otherwise = "positive";
