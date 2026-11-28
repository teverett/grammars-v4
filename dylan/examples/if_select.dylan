define method describe (n :: <integer>) => (result :: <string>)
  if (n < 0)
    "negative"
  elseif (n = 0)
    "zero"
  else
    "positive"
  end if;
end method describe;

define method weekday-name (n :: <integer>) => (result :: <string>)
  select (n by \=)
    1, 2 => "early week";
    3    => "midweek";
    otherwise => "other";
  end select
end method weekday-name;
