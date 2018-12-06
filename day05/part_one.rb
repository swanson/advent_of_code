polymer = File.open("day05/input.txt").read

# polymer = "dabAcCaCBAcCcaDA"

units = polymer.chars
c = 0
while true
  actions = 0
  puts units.length, c

  u = units.shift
  new_polymer = [u]

  while units.any?
    u = units.shift
    if u.swapcase == new_polymer.last
      new_polymer.pop
      actions += 1
    else
      new_polymer << u
    end
  end

  units = new_polymer

  break if actions == 0
end

puts units.join, units.length