define library my-app
  use dylan;
  use common-dylan;
  export my-app;
end library my-app;

define module my-app
  use dylan;
  use common-dylan, import: all;
  use io, exclude: {skew-line};
  export <point>, point-x, point-y;
  create $pi;
end module my-app;
