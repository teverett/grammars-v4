"An object-level comment annotation and a categorized group of slots."
( | {} = 'this object has one grouped category'.
    {
      'Category: accessing'
      getOne = ( 1 ).
      getTwo = ( 2 ).
    }
  |
    (getOne + getTwo) printLine
)
