"A parent slot that is assignable, enabling dynamic inheritance."
( | parent* <- traits clonable.
    label <- 'untitled'.
  |
    self parent: traits oddball
)
