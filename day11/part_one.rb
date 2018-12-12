$serial_number = 3613

class Cell < Struct.new(:x, :y, :sn)
  def rack_id
    x + 10
  end

  def power_level
    @power_level ||= calc_pl
  end

  def calc_pl
    pl = rack_id * y
    pl += sn
    pl *= rack_id
    if pl > 100
      pl = pl.to_s.split("")[-3].to_i
    else
      p1 = 0
    end
    pl -= 5
    pl
  end
end

def cell_at(x, y, cells)
  cells.find{|c| c.x == x && c.y == y}
end

cells = Hash.new
(0..299).each do |x|
  cells[x] = []
  (0..299).each do |y|
    cells[x][y] = Cell.new(x+1, y+1, $serial_number)
  end
end

max_power_level = 0
max_cell = nil

grids = []

(0..297).each do |x|
  (0..297).each do |y|
    sum = 0

    3.times do |dx|
      3.times do |dy|
        sum += cells[x+dx][y+dy].power_level
      end
    end

    if sum > max_power_level
      max_power_level = sum
      max_cell = cells[x][y]
    end
  end
end

puts max_cell.inspect