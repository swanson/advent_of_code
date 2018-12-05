polymer = File.open("day05/input.txt").read

# polymer = "dabAcCaCBAcCcaDA"

c = 0

while true
  actions = 0
  puts polymer.length, c

  new_polymer = []

  polymer.chars.each_with_index do |unit, idx|
    break if idx == polymer.length - 1

    next_unit = polymer.chars[idx + 1]
    if next_unit.swapcase == new_polymer.last
      actions += 1
      new_polymer.pop
    else
      new_polymer << unit
    end
  end

  polymer = new_polymer.join

  break if actions == 0
end

puts polymer, polymer.length