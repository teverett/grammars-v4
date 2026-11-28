define function factorial (n :: <integer>) => (n! :: <integer>)
  case
    n < 0     => error("Can't take factorial of negative integer: %d\n", n);
    n = 0     => 1;
    otherwise => n * factorial(n - 1);
  end
end function factorial;
