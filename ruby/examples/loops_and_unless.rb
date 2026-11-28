x = 10
unless x.zero?
  puts "x is not zero"
end

count = 0
until count >= 3
  count += 1
end
puts count

for i in 1..3
  puts i
end

puts "done" if x > 5
puts "skipped" unless x > 5
