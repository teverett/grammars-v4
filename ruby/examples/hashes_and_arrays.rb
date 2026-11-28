config = { name: "test", values: [1, 2, 3], nested: { a: 1 } }
puts config[:name]

arr = [1, 2, 3, 4, 5]
evens = arr.select { |n| n.even? }
puts evens.inspect

pairs = { "a" => 1, "b" => 2 }
pairs.each do |k, v|
  puts "#{k}: #{v}"
end
