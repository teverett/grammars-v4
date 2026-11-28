def classify(n)
  if n < 0
    "negative"
  elsif n == 0
    "zero"
  else
    "positive"
  end
end

numbers = [1, -2, 0, 3, -4]
numbers.each do |n|
  puts classify(n)
end

total = 0
i = 0
while i < 10
  total += i
  i += 1
end
puts total

case total
when 0..10 then puts "small"
when 11..100 then puts "medium"
else puts "large"
end
