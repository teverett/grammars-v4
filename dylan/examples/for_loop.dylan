define method sum-to (n :: <integer>) => (total :: <integer>)
  let total = 0;
  for (i from 1 to n)
    total := total + i;
  finally
    total;
  end for
end method sum-to;

define method collect-squares (coll :: <vector>) => (result :: <vector>)
  for (x in coll,
       i from 0 below 10 by 1)
    x * x;
  end for
end method collect-squares;
