NUM_PLAYERS = 462
MAX_MARBLE = 71938 * 100

players = Array.new(NUM_PLAYERS) {|i| 0}
marble_number = 0

class Marble < Struct.new(:number, :cw, :ccw)
  def move_counter(n)
    x = self
    n.times { x = x.ccw}
    x
  end
end;

def insert_after(existing_marble, new_marble)
  b = existing_marble.cw
  existing_marble.cw = new_marble
  new_marble.ccw = existing_marble
  new_marble.cw = b
  b.ccw = new_marble
  new_marble
end

def remove(marble)
  p = marble.ccw
  p.cw = marble.cw
  n = marble.cw
  n.ccw = p
  [n, marble]
end

current_marble = Marble.new(marble_number, nil, nil)
current_marble.cw = current_marble
current_marble.ccw = current_marble

puts "Game starting"
start_time = Time.now
percentage = 0

while true
  players.each_with_index do |score, player|
    if marble_number % (MAX_MARBLE / 100) == 0
      percentage += 1
      puts "Reached marble: #{marble_number} (#{percentage}%)"
      puts "Running for: #{(Time.now - start_time).round} seconds"
    end

    if marble_number == MAX_MARBLE
      puts "Players: #{NUM_PLAYERS}"
      puts "Max Marble: #{MAX_MARBLE}"
      puts "Game Over\n"
      puts "High score: #{players.max}"
      exit
    end

    marble_number += 1
    marble = Marble.new(marble_number, nil, nil)

    if marble_number % 23 == 0
      current_marble = current_marble.move_counter(7)
      current_marble, removed = remove(current_marble)
      players[player] += removed.number + marble_number
    else
      current_marble = insert_after(current_marble.cw, marble)
    end
  end
end

# 3212830280