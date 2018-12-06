file = File.open("day06/input.txt").read
# file="1, 1
# 1, 6
# 8, 3
# 3, 4
# 5, 5
# 8, 9"
lines = file.split("\n")
print_out = false

class Target < Struct.new(:x, :y, :distance)
  def match?(x, y)
    x == self.x && y == self.y
  end

  def distance_from(x2, y2)
    (x2-x).abs + (y2-y).abs
  end
end

coords = []
letter = 0
lines.each do |l|
  x, y = l.split(",")
  coords << Target.new(x.to_i, y.to_i, letter)
  letter += 1
end

max_x = coords.max_by{|c| c.x}.x
max_y = coords.max_by{|c| c.y}.y

all_points = []

(0..max_y).each do |y|
  puts "\n" if print_out
  (0..max_x).each do |x|
    total_d = coords.sum{|c| c.distance_from(x, y)}
    all_points << Target.new(x, y, total_d)
  end
end

puts "Done mapping."
puts "\n\n"

safe_points = 0

all_points.each do |p|
  if p.distance < 10000
    safe_points += 1
  end
end

puts safe_points
