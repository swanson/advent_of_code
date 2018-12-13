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
    return nil if @index < -1000
    pot = Pot.new(false, @index - 1)
    pot.right = self
    self.left = pot
    $pots.append(pot)
    pot
  end

  def build_right!
    return nil if @index > 1000
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

def current_sum
  sum = 0
  $pots.each do |p|
    if p.current_state
      sum += p.index
    end
  end
  sum
end

generation = 0
spread = 0
last_spread = 0
spread_unchanged = 0
last_sum = 0

while generation < 1000
  if spread_unchanged > 50
    puts "Not converging"
    puts "Sum at 50 bill:"
    print ((50_000_000_000 - generation) * (current_sum - last_sum)) + current_sum
    exit
  end
  
  print "#{generation}:\t\t"

  min = $pots.select{|p| p.current_state}.min_by{|p|p.index}.index
  max = $pots.select{|p| p.current_state}.max_by{|p|p.index}.index
  (min..max).each do |i|
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

  spread = max - min

  if spread != last_spread
    last_spread = spread
    spread_unchanged = 0
  else
    spread_unchanged += 1
  end

  puts "\n"
  generation += 1
  last_sum = current_sum

  $pots.each do |p|
    p.compute_next_state
  end

  $pots.each do |p|
    p.tick!
  end

end
puts "\n"


