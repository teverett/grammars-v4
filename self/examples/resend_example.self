"Undirected and directed resend, each with a different message kind."
( | parent* = traits oddball.
    listParent* = traits list.

    display = ( resend.display ).
    height = ( listParent.height ).
    combine: other = ( resend.min: 17 Max: 23 ).
    bump = ( resend.+ 5 ).
  |
)
