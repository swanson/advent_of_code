file = File.open("day06/input.txt").read
# file="1, 1
# 1, 6
# 8, 3
# 3, 4
# 5, 5
# 8, 9"
lines = file.split("\n")
print_out = false

class Target < Struct.new(:x, :y, :letter)
  def match?(x, y)
    x == self.x && y == self.y
  end

  def distance_from(x2, y2)
    (x2-x).abs + (y2-y).abs
  end

  def unbounded?(x2, y2)
    x == 0 || y == 0 || x == x2 || y == y2
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

def closest_target(coords, x, y)
  h = Hash.new
  coords.map do |c|
    d = c.distance_from(x, y)
    h[d] ||= []
    h[d] << c
  end

  min_h = h.min_by{|k,v| k}
  targets = min_h[1]
  if targets.count != 1
    nil
  else
    targets.first
  end
end

all_points = []

(0..max_y).each do |y|
  puts "\n" if print_out
  (0..max_x).each do |x|
    target = coords.select{|c| c.match?(x,y)}.first
    if target
      print target.letter if print_out
    else
      t = closest_target(coords, x, y)
      if t
        all_points << Target.new(x, y, t.letter )
        print t.letter.downcase if print_out
      else
        print "." if print_out
      end
    end
  end
end

puts "Done mapping."
puts "\n\n"

bounded_letters = all_points.map{|p| p.letter}.uniq

all_points.each do |p|
  if p.unbounded?(max_x, max_y)
    bounded_letters.delete(p.letter)
  end
end

puts "Bounded:"
puts bounded_letters.inspect

results = Hash.new(0)
all_points.each do |p|
  if bounded_letters.include? p.letter
    results[p.letter] += 1
  end
end

answer = results.max_by{|k, v| v}
puts answer[1] + 1
