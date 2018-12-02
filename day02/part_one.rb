file = File.open("day02/input.txt")
lines = file.read.split("\n")

twos = 0
threes = 0

lines.each do |line|
  counts = Hash.new(0)
  line.each_char.each_with_object(counts) {|c,h| h[c] += 1}

  twos += 1 if counts.values.include? 2
  threes += 1 if counts.values.include? 3
end

puts twos * threes