define method countdown (n :: <integer>) => (result :: <integer>)
  let x = n;
  while (x > 0)
    x := x - 1;
  end while;
  x
end method countdown;

define method wait-for-ready (device :: <object>) => ()
  until (ready?(device))
    sleep(1);
  end until;
end method wait-for-ready;
