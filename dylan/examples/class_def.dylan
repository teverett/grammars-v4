define class <point> (<object>)
  slot point-x :: <integer>,
    required-init-keyword: x:;
  slot point-y :: <integer>,
    required-init-keyword: y:;
  constant slot point-name :: <string> = "origin",
    init-keyword: name:;
end class <point>;

define sealed class <colored-point> (<point>)
  slot point-color :: <symbol> = #"black";
  keyword visible?: = #t;
  inherited slot point-name = "colored";
end class <colored-point>;
