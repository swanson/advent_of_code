file = File.open("day02/input.txt")
lines = file.read.split("\n")

sorted = []

def difference(a, b)
  diff = 0
  common = []

  a.chars.zip(b.chars) do |a, b|
    if a == b
      common << a
    else
      diff += 1
    end
  end

  [diff, common.join]
end


lines.each do |a|
  lines.each do |b|
    diff, common = difference(a, b)
    
    if diff == 1
      puts a, b
      puts "Answer:", common
      exit
    end
  end
end
