begin
  raise ArgumentError, "bad value"
rescue ArgumentError => e
  puts e.message
rescue StandardError
  puts "other error"
else
  puts "no error"
ensure
  puts "done"
end

def risky
  yield
rescue RuntimeError
  "recovered"
end
