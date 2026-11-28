x = 5
y = x > 0 ? "positive" : "non-positive"
puts y

n = nil
result = n&.to_s
puts result.nil?

str = n&.upcase || "default"
puts str
