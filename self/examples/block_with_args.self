"A block with declared arguments and local slots, used as a map-like loop."
( |
    printEach: aCollection = (
        aCollection do: [ | :each | each printLine ]
    ).
  |
    myList printEach: myList
)
