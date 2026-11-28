module class_instance;

import StdEnv;

:: Shape = Circle Real | Square Real;

class Area a where {
    area :: a -> Real;
};

instance Area Shape where {
    area (Circle r) = 3.14159 * r * r;
    area (Square s) = s * s;
};

totalArea :: [Shape] -> Real;
totalArea shapes = sum [ area s \\ s <- shapes];
