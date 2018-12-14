file = File.open("day13/input.txt").read
# file =
# '/->-\        
# |   |  /----\
# | /-+--+-\  |
# | | |  | v  |
# \-+-/  \-+--/
#   \------/   '


lines = file.split("\n")
x = lines.first.length
y = lines.length

class Cart < Struct.new(:id, :x, :y, :next_turn, :facing)
  def tick!(grid)
    if facing?(:right)
      dx=x+1; dy=y 
    elsif facing?(:left)
      dx=x-1; dy=y;
    elsif facing?(:down)
      dx=x;dy=y+1;
    else
      dx=x;dy=y-1;
    end

    next_track = grid[dy][dx]
    intersection = false
    df = facing
    case next_track
    when "\\"
      if facing?(:right)
        df = :down
      elsif facing?(:left)
        df = :up
      elsif facing?(:down)
        df = :right
      else
        df = :left
      end
    when "/"
      if facing?(:right)
        df = :up
      elsif facing?(:left)
        df = :down
      elsif facing?(:down)
        df = :left
      else
        df = :right
      end  
    when "+"
      intersection = true
      if facing?(:right)
        if next_turn == :left
          df = :up
        elsif next_turn == :right
          df = :down
        end
      elsif facing?(:left)
        if next_turn == :left
          df = :down
        elsif next_turn == :right
          df = :up
        end
      elsif facing?(:down)
        if next_turn == :left
          df = :right
        elsif next_turn == :right
          df = :left
        end
      else
        if next_turn == :left
          df = :left
        elsif next_turn == :right
          df = :right
        end
      end      
    else
      # nothing, move along
    end

    self.x = dx
    self.y = dy
    self.facing = df
    self.next_turn = cycle_turn(intersection)
  end

  def facing?(dir)
    facing == dir
  end

  def cycle_turn(cycle)
    return next_turn unless cycle

    if next_turn == :left
      :straight
    elsif next_turn == :straight
      :right
    else
      :left
    end
  end

  def to_s
    case facing
    when :down
      "v"
    when :up
      "^"
    when :left
      "<"
    else
      ">"
    end
  end
end


grid = []
carts = []

(0..y-1).each do |j|
  grid[j] = []
  (0..x-1).each do |i|
    c = lines[j].chars[i]

    if c == "v"
      carts << Cart.new(('a'..'z').to_a[carts.length], i, j, :left, :down)
      grid[j] << "|"
    elsif c == "^"
      carts << Cart.new(('a'..'z').to_a[carts.length], i, j, :left, :up,)
      grid[j] << "|"
    elsif c == "<"
      carts << Cart.new(('a'..'z').to_a[carts.length], i, j, :left, :left)
      grid[j] << "-"
    elsif c == ">"
      carts << Cart.new(('a'..'z').to_a[carts.length], i, j, :left, :right)
      grid[j] << "-"
    else
      grid[j] << c
    end
  end
end


def print_world(grid, carts)
  puts "\r"
  x = grid.first.length
  y = grid.length

  (0..y-1).each do |j|
    print "\n"
    (0..x-1).each do |i|
      cart = carts.find{|c| c.x == i && c.y == j}
      if cart
        #print cart.id
        print cart
      else
        print grid[j][i]
      end
    end
  end 
  puts "\n\n"
  puts carts.inspect
end

def check_crashes(grid, carts)
  pos = Hash.new(0)
  carts.each do |c|
    key = "#{c.x},#{c.y}"
    pos[key] += 1
    if pos[key] > 1
      print_world(grid, carts)
      puts "Crash! at #{$ticks}"
      puts c.id
      puts key
      exit
    end
  end
end

$ticks = 0
while true
  # print_world(grid, carts)
  carts
    .sort_by{|c| [c.y, c.x] }
    .map {|c| c.tick!(grid); check_crashes(grid, carts); }
  
  $ticks += 1
end