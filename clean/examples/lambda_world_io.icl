module lambda_world_io;

import StdEnv;

addOne :: Int -> Int;
addOne = \x -> x + 1;

compose2 :: (b -> c) (a -> b) a -> c;
compose2 f g x = f (g x);

Start :: *World -> *World;
Start w = snd (stdio_write "hello" w);

stdio_write :: String *World -> (Int, *World);
stdio_write s w = (0, w);
