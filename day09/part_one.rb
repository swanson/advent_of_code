NUM_PLAYERS = 462
MAX_MARBLE = 71938 * 100

players = Array.new(NUM_PLAYERS) {|i| 0}
marble_number = 0

circle = [marble_number]

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
      # puts players.inspect
      puts "High score: #{players.max}"
      exit
    end

    marble_number += 1
    # print "[#{player +1 }] "

    if marble_number % 23 == 0
      players[player] += marble_number
      # puts "Score #{marble_number}"
      circle.rotate!(-7)
      removed = circle.shift
      # puts "Score #{removed}"
      players[player] += removed
    else
      circle.rotate!(2)
      circle.insert(0, marble_number)
    end

    # puts circle.inspect
  end
end