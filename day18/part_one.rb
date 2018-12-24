file = File.open("day18/input.txt").read
# file = '.#.#...|#.
# .....#|##|
# .|..|...#.
# ..|#.....#
# #.#|||#|#|
# ...#.||...
# .|....|...
# ||...#|.#|
# |.||||..|.
# ...#.|..|.'

lines = file.split("\n")

class Cell < Struct.new(:current, :x, :y, :ns)
  def at(x, y); self.x == x && self.y == y; end;
  
  def tick!; self.current = self.ns; end;

  def set_next_state(map)
    adjacent = []
    (-1..1).each do |dx|
      (-1..1).each do |dy|
        next if dx == 0 && dy == 0
        adjacent << map[y+dy][x+dx] if map[y+dy]
      end
    end
    adjacent.flatten!
    adjacent.compact!

    self.ns = current

    if open?
      self.ns = :tree if adjacent.count{|c| c.tree?} >= 3
    elsif tree?
      self.ns = :yard if adjacent.count{|c| c.yard?} >= 3
    else
      if adjacent.count{|c| c.yard?} >= 1 && adjacent.count{|c| c.tree?} >= 1
        self.ns = :yard
      else
        self.ns = :open
      end
    end
  end

  def open?; current == :open; end
  def tree?; current == :tree; end
  def yard?; current == :yard; end
  
  def to_s
    case current
    when :open
      "."
    when :tree
      "|"
    when :yard
      "#"
    end
  end
end

cells = []
round = 0
map = Hash.new

max_x = lines.first.chars.length - 1
max_y = lines.length - 1

lines.each_with_index do |l, y|
  map[y] = Hash.new
  l.chars.each_with_index do |c, x|
    state = :open
    if c == "|"
      state = :tree
    elsif c == "#"
      state = :yard
    end

    cell = Cell.new(state, x, y, state)
    cells << cell
    map[y][x] = cell
  end
end

def print_world(cells, round = 0)
  max_x = cells.max_by{|c| c.x}.x
  max_y = cells.max_by{|c| c.y}.y

  print "After #{round} minute:"
  (0..max_y).each do |y|
    print "\n"
    (0..max_x).each do |x|
      print cells.find{|c| c.at(x, y)}
    end
  end
  print "\n\n"
end

def value(cells)
  tc = cells.count{|c| c.tree?}
  yc = cells.count{|c| c.yard?}
  tc * yc
end

1000000000.times do |i|
  # print_world(cells, round)
  cells.map{|c| c.set_next_state(map)}
  cells.map{|c| c.tick!}
  round += 1

  if i > 1310 && i < 1350
    value = value(cells)
    puts "#{i}: #{value}"
  end

  if i > 1350
    exit
  end

  puts "#{i}% done" if i % 10000000 == 0 
end

print_world(cells, round)

tc = cells.count{|c| c.tree?}
yc = cells.count{|c| c.yard?}
oc = cells.count{|c| c.open?}

puts "trees: #{tc}\tyards: #{yc}\topen: #{oc}"
puts "Answer: #{tc*yc}"

# part a: 506385
# part b: 215404 -- wait for pattern, module math