require_relative "version"
require_relative "path_finder"
require_relative "search_area"

class Goblin < Struct.new(:x, :y, :ap, :hp)
  def goblin?; true; end;
  def alive?; hp > 0; end;
  def to_s; "G(#{hp}) "; end;
end

class Elf < Struct.new(:x, :y, :ap, :hp)
  def goblin?; false; end;
  def alive?; hp > 0; end;
  def to_s; "E(#{hp}) "; end;
end

class Wall < Struct.new(:x, :y); end;

# class Path < Pathfinding
#   def initialize(w, h, z, o)
#     @other_units = o
#     super(w, h, z)
#   end

#   def blocked?(x,y)
#     $map[y][x] == "#" || @other_units.any?{|u| u.x == x && u.y ==y}
#   end
# end

def units_turn_order
  $units.sort_by{|u| [u.y, u.x]}
end

def goblins
  $units.select{|u| u.goblin?}
end

def elfs
  $units.select{|u| !u.goblin?}
end

def enemies(unit)
  $units.select{|u| u.goblin? != unit.goblin?}
end

def unit_at(x, y)
  $units.find{|u| u.x == x && u.y == y}
end

def enemy_at(unit, x, y)
  enemies(unit).find{|u| u.x == x && u.y == y}
end

def open_square_at?(x,y)
  unit_at(x,y).nil? && $map[y][x] == "."
end

def other_units(unit, target)
  $units.reject{|u| u == unit || u == target}
end

def other_units(unit)
  $units.reject{|u| u == unit}
end

def in_range?(unit)
  x = unit.x
  y = unit.y
  coords = []
  if open_square_at?(x, y-1)
    coords << [x, y-1]
  end
  if open_square_at?(x-1, y)
    coords << [x-1, y]
  end
  if open_square_at?(x+1, y)
    coords << [x+1, y]
  end
  if open_square_at?(x, y+1)
    coords << [x, y+1]
  end
  coords
end

def free_spots_adjacent(unit)
  in_range?(unit)
end

def targets_for?(unit)
  targets = []
  enemies(unit).each do |e|
    in_range?(e).each do |r|
      targets << r
    end
  end
  targets
end

def enemies_in_range(unit)
  x = unit.x
  y = unit.y

  eir = []
  eir << enemy_at(unit, x, y+1)
  eir << enemy_at(unit, x, y-1)
  eir << enemy_at(unit, x+1, y)
  eir << enemy_at(unit, x-1, y)
  eir.compact.sort_by{|e| e.hp}
end

def attack!(unit, victim)
  # puts "Attacked: #{victim} by #{unit}"
  victim.hp -= unit.ap
  unless victim.alive?
    $units.delete(victim) 
  end
end

def check_endgame(round)
  outcome = nil
  if goblins.empty?
    total_hp = 0
    elfs.map{|u| total_hp += u.hp}
    outcome = round * total_hp
    puts "Combat ends after #{round}"
    puts "Elfs win: #{total_hp}"
  end

  if elfs.empty?
    total_hp = 0
    goblins.map{|u| total_hp += u.hp}
    outcome = round * total_hp
    puts "Combat ends after #{round}"
    puts "Goblins win: #{total_hp}"
  end

  outcome
end

def print_world(round)
  puts "After #{round} rounds:"
  $map.each_with_index do |row, i|
    units = []
    row.each_with_index do |v, j|
      unit = unit_at(j,i)
      if unit
        units << unit
        if unit.goblin?
          print "G"
        else
          print "E"
        end
      else
        print v
      end
    end
    print "\t"
    units.map{|u| print u}
    puts "\n"
  end

  puts "\n"
end

def run(file, print_enabled = false)
  lines = file.split("\n")
  
  x = lines.first.chars.length
  y = lines.length
  
  $map = []
  $units = []
  $walls = []

  
  (0..y-1).each do |y|
    $map[y] = []
    (0..x-1).each do |x|
      c = lines[y].chars[x]
  
      if c == "G"
        $units << Goblin.new(x, y, 3, 200)
        c = "."
      elsif c == "E"
        $units << Elf.new(x, y, 3, 200)
        c = "."
      elsif c == "#"
        $walls << Wall.new(x,y)
      end
  
      $map[y] << c
    end
  end

  round = 0

  while true # round < 5
    print_world(round) if print_enabled

    units_turn_order.each do |unit|
      next unless unit.alive?

      outcome = check_endgame(round)
      if outcome
        print_world(round)
        return outcome 
      end

      # puts "Turn for #{unit}"

      # Started in range of enemy, attack and end
      eir = enemies_in_range(unit)
      if eir.any?
        attack!(unit, eir.first)
        next
      end

      # Find somewhere to move
      possible_targets = []
      units_turn_order.each do |u|
        next if u == unit
        next if u.goblin? == unit.goblin?
        free_spots_adjacent(u).each do |s|
          possible_targets << s
        end
      end

      sa = Ruby::Pathfinding::SearchArea.new(x, y)
      start_loc = Ruby::Pathfinding::Point.new(unit.x, unit.y)
      other_units(unit).each do |b|
        sa.put_collision(b.x, b.y) if b.alive?
      end
      $walls.each do |w|
        sa.put_collision(w.x, w.y)
      end

      closest_target = nil
      closest_path = nil
      closest_distance = 999999

      possible_targets.each do |coord|
        destination = Ruby::Pathfinding::Point.new(coord[0], coord[1])
        pf = Ruby::Pathfinding::PathFinder.new(sa,start_loc,destination)
        pf.find_path

        next if pf.path.nil?

        if pf.path.length < closest_distance
          closest_target = coord
          closest_distance = pf.path.length
          closest_path = pf.path
        end
      end

      next if closest_path.nil?

      closest_path.shift # first element is current position

      unit.x = closest_path.first.x
      unit.y = closest_path.first.y
      
      # In range to attack after move (OP)
      eir = enemies_in_range(unit)
      if eir.any?
        attack!(unit, eir.first)
        next
      end
    end

    round += 1
  end
end

def assert(input, expected, print_enabled = false)
  actual = run(input, print_enabled) 

  if expected.nil?
    puts "Puzzle answer: #{actual}"
    return
  end

  if actual == expected
    puts "PASSED: #{actual}"
  else
    puts "FAILED: Expected #{expected}, but was #{actual}"
    exit
  end
  puts "\n\n"
end

assert(
'#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######', 27730, true)

assert(
'#######
#G..#E#
#E#E.E#
#G.##.#
#...#E#
#...E.#
#######', 36334)

assert(
'#######
#E..EG#
#.#G.E#
#E.##E#
#G..#.#
#..E#.#
#######', 39514)

assert(
'#######
#E.G#.#
#.#G..#
#G.#.G#
#G..#.#
#...E.#
#######', 27755)

assert(
'#######
#.E...#
#.#..G#
#.###.#
#E#G#G#
#...#G#
#######', 28944)

assert(
'#########
#G......#
#.E.#...#
#..##..G#
#...##..#
#...#...#
#.G...G.#
#.....G.#
#########', 18740)

assert(
'#########
#G..G..G#
#.......#
#.......#
#G..E..G#
#.......#
#.......#
#G..G..G#
#########', 27828)

file = File.open("day15/input.txt").read
puts "Solving puzzle..."
assert(file, 196200, true)

# 196200