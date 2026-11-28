module Shapes
  class Circle
    def initialize(radius)
      @radius = radius
    end

    def area = Math::PI * @radius ** 2
  end
end

c = Shapes::Circle.new(2)
puts c.area
