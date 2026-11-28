module operators_fixity;

import StdEnv;

(^) infixr 8 :: Int Int -> Int;
(^) x 0 = 1;
(^) x n = x * (x ^ (n - 1));

(o) infixr 9 :: (b -> c) (a -> b) -> (a -> c);
(o) f g = \x -> f (g x);

:: Vec = { vx :: !Real, vy :: !Real };

addVec :: Vec Vec -> Vec;
addVec v1 v2 = { vx = v1.vx + v2.vx, vy = v1.vy + v2.vy };

Start :: Int;
Start = 2 ^ 10;
