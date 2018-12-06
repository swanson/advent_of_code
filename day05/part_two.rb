polymer = File.open("day05/input.txt").read

# polymer = "dabAcCaCBAcCcaDA"

candidates = polymer.downcase.chars.uniq
results = Hash.new(0)

candidates.each do |c|
  units = polymer.tr(c, '').tr(c.swapcase, '').chars
  
  while true
    actions = 0

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

  results[c] = units.length
end

puts results.inspect
puts results.min_by{|k,v| v}