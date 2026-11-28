define method safe-divide (a :: <integer>, b :: <integer>) => (result :: <integer>)
  block (return)
    if (b = 0)
      return(0);
    end if;
    a / b
  exception (<error>)
    0
  end block
end method safe-divide;

define method compute (x :: <integer>) => (result :: <integer>)
  local method square (n) n * n end,
        method cube (n) n * square(n) end;
  begin
    cube(x) + square(x);
  end
end method compute;

define method split-values () => (a, b)
  let (a, b) = values(1, 2);
  a + b
end method split-values;
