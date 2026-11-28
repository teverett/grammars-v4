"A keyword method slot and a plain keyword message send."
( |
    min: a Max: b = ( a < b ifTrue: [ a ] False: [ b ] ).
  |
    (5 min: 4 Max: 7) printLine
)
