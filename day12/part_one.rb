files = File.open('day12/input.txt').read
# files = "initial state: #..#.#..##......###...###

# ...## => #
# ..#.. => #
# .#... => #
# .#.#. => #
# .#.## => #
# .##.. => #
# .#### => #
# #.#.# => #
# #.### => #
# ##.#. => #
# ##.## => #
# ###.. => #
# ###.# => #
# ####. => #"

class Pot
  attr_accessor :left, :right, :index, :current_state, :next_state

  def initialize(initial_state, index)
    @current_state = initial_state
    @next_state = @current_state
    @index = index
  end
  
  def to_s
    if @current_state
      "#"
    else
      "."
    end
  end

  def build_left!
    return nil if @index < -200
    pot = Pot.new(false, @index - 1)
    pot.right = self
    self.left = pot
    $pots.append(pot)
    pot
  end

  def build_right!
    return nil if @index > 200
    pot = Pot.new(false, @index + 1)
    pot.left = self
    self.right = pot
    $pots.append(pot)
    pot
  end   

  def pattern   
    p = []

    if left.nil?
      p.insert(0, "..")
      build_left!
    elsif left.left.nil?
      p.insert(0, left.to_s)
      p.insert(0, ".")
    else
      p.insert(0, left.to_s)
      p.insert(0, left.left.to_s)
    end

    p.append(self.to_s)

    if right.nil?
      p.append("..")
      build_right!
    elsif right.right.nil?
      p.append(right.to_s)
      p.append(".")
    else
      p.append(right.to_s)
      p.append(right.right.to_s)
    end

    p.join("")
  end

  def compute_next_state
    alive = $rules[pattern] == "#"
    @next_state = alive
  end

  def tick!
    @current_state = @next_state
  end
end

lines = files.split("\n")

$rules = Hash.new(".")
lines[2..-1].each do |l|
  key, value = l.split("=>")
  $rules[key.strip] = value.strip
end

$pots = []

initial_state = lines[0][15..-1]
max_size = initial_state.chars.size
initial_state.chars.each_with_index do |c, i|
  $pots << Pot.new(c == "#", i)
end

$pots.each_with_index do |p, i|
  if i != 0
    p.left = $pots[i - 1]
  end

  if  i != max_size - 1
    p.right = $pots[i + 1]
  end
end

generation = 0

while generation < 20
  print "#{generation}:\t\t"

  (-50..150).each do |i|
    pot = $pots.find{|p| p.index == i}
    if i == 0
      print "0"
    end
    if pot
      print pot
    else
      print "."
    end
  end

  puts "\n"
  generation += 1

  $pots.each do |p|
    p.compute_next_state
  end

  $pots.each do |p|
    p.tick!
  end
end
puts "\n"

sum = 0
$pots.each do |p|
  if p.current_state
    sum += p.index
  end
end

puts sum
