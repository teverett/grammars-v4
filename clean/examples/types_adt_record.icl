module types_adt_record;

import StdEnv;

:: Tree a = Node a (Tree a) (Tree a) | Leaf;

:: Point = { x :: Int, y :: Int };

:: Complex :== (Real, Real);

origin :: Point;
origin = { x = 0, y = 0 };

moveX :: Point Int -> Point;
moveX p dx = { p & x = p.x + dx };

depth :: (Tree a) -> Int;
depth Leaf = 0;
depth (Node v l r) = 1 + depth l;
