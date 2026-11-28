define generic area (shape :: <object>) => (result :: <number>);

define method area (shape :: <point>) => (result :: <integer>)
  0
end method area;

define sealed domain area (<point>);

define method \+ (p1 :: <point>, p2 :: <point>) => (sum :: <point>)
  make(<point>, x: p1.point-x + p2.point-x, y: p1.point-y + p2.point-y)
end method \+;
