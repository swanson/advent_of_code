file = File.open("day03/input.txt")
lines = file.read.split("\n")

class Claim < Struct.new(:id, :x, :y, :w, :h, :intact)
end

claims = []
cells = Hash.new(0)
size = 1000

lines.each do |l|
  parts = l.split(" ")
  id = parts[0]
  x, y = parts[2].split(",")
  w, h = parts.last.split("x")
  claims << Claim.new(id, x.to_i, y.to_i, w.to_i, h.to_i, true)
end

(0..size).each do |x|
  cells[x] = Hash.new(0)
  (0..size).each do |y|
    cells[x][y] = 0
  end
end

claims.each do |c|
  puts "processing claim: #{c.id}"
  (c.x..c.x+c.w-1).each do |x|
    (c.y..c.y+c.h-1).each do |y|
      cells[x][y] += 1
    end
  end
end


claims.each do |c|
  puts "processing claim: #{c.id}"
  (c.x..c.x+c.w-1).each do |x|
    (c.y..c.y+c.h-1).each do |y|
      if cells[x][y] > 1
        c.intact = false
      end
    end
  end
end

puts claims.select{|c| c.intact}.first


