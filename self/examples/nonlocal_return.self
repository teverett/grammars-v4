"A non-local return from inside a block, and the trailing '^' return form."
( |
    assertPositive: x = (
        x > 0 ifTrue: [ ^ 'ok' ].
        self error: 'non-positive x'
    ).
  |
    ^ (5 assertPositive: 3)
)
