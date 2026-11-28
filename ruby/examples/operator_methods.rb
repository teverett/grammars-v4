class Vector
  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(other)
    Vector.new(@x + other.x, @y + other.y)
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def x = @x
  def y = @y
end

v1 = Vector.new(1, 2)
v2 = Vector.new(3, 4)
v3 = v1 + v2
puts v3 == v3
