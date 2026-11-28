square = ->(x) { x * x }
puts square.call(5)

a, b = 1, 2
a, b = b, a
puts "#{a}, #{b}"

def sum(*nums, factor: 1, **opts)
  nums.map { |n| n * factor }.reduce(:+)
end

puts sum(1, 2, 3, factor: 2)
