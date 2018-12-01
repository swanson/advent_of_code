file = File.open("day01/input.txt")

frequency = 0
file.read.split("\n").each do |line|
  eval("frequency += #{line}")
end

p frequency