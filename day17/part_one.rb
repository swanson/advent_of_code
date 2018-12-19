file = File.open("day17/input.txt").read
file ='x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=1..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504'

lines = file.split("\n")

class Point < Struct.new(:x, :y)
  def at(x, y); self.x == x && self.y == y; end
end

clay = []
lines.each do |l|
  nums = l.scan(/\d+/)
  if l.start_with? "x"
    (nums[1]..nums[2]).each do |y|
      clay << Point.new(nums[0].to_i, y.to_i)
    end
  else
    (nums[1]..nums[2]).each do |x|
      clay << Point.new(x.to_i, nums[0].to_i)
    end
  end
end

def print_world(clay, water)
  max_y = clay.max_by{|c| c.y}.y + 1
  min_x = clay.min_by{|c| c.x}.x - 1
  max_x = clay.max_by{|c| c.x}.x + 1

  (0..max_y).each do |y|
    print "\n"
    (min_x..max_x).each do |x|
      if y == 0 && x == 500
        print "+"
        next
      end

      if clay.find{|c| c.at(x,y)}
        print "#"
      elsif water.find{|c| c.at(x,y)}
        print "~"
      else
        print "."
      end
    end
  end
  print "\n\n"
end

def clay?(clay, x, y)
  clay.find{|c| c.at(x,y)}
end

def water?(water, x, y)
  water.find{|c| c.at(x,y)}
end

def sand?(clay, water, x, y)
  clay?(clay, x, y).nil? && water?(water, x, y).nil?
end

def fill(clay, water, x, y)
  if clay?(clay, x, y)
    return false
  end

  if sand?(clay, water, x, y)
    water << Point.new(x, y)
    return true
  end

  down = fill(clay, water, x, y + 1)
  return down if down

  left = fill(clay, water, x - 1, y)
  return left if left

  right = fill(clay, water, x + 1, y)
  return right if right

  a = fill(clay, water, x - 1, y - 1)
  return a if a

  b = fill(clay, water, x + 1, y - 1)
  return b if b

  puts "Could not fill anymore"
  return false
end

def find_place(clay, water)
  x = 500
  y = 1

  while sand?(clay, water, x, y)
    if clay?(clay, x, y + 1)
      return [x, y]
    end

    y += 1
  end
end

water = []
20.times do
  puts "Water: #{water.length}"
  # x, y = find_place(clay, water)
  # water << Point.new(x, y)
  fill(clay, water, 500, 0)
  
  print_world(clay, water)
end


