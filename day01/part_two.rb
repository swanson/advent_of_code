file = File.open("day01/input.txt")

frequency = 0
counts = Hash.new(0)
changes = file.read.split("\n")
calibrated = false

while !calibrated do
  changes.each do |line|
    eval("frequency += #{line}")
    counts[frequency] += 1

    if counts[frequency] == 2
      calibrated = true
      break
    end
  end
end

p frequency