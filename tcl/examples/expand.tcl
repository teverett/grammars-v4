set coords {1 2 3}
proc point3d {x y z} {
    puts "$x,$y,$z"
}
point3d {*}$coords
