file = File.open("day23/input.txt").read
# file = 'pos=<0,0,0>, r=4
# pos=<1,0,0>, r=1
# pos=<4,0,0>, r=3
# pos=<0,2,0>, r=1
# pos=<0,5,0>, r=3
# pos=<0,0,3>, r=1
# pos=<1,1,1>, r=1
# pos=<1,1,2>, r=1
# pos=<1,3,1>, r=1'

lines = file.split("\n")

class Bot < Struct.new(:x, :y, :z, :r)
end

bots = []
lines.each do |line|
  x, y, z, r = line.scan(/-*\d+/)
  bots << Bot.new(x.to_i, y.to_i, z.to_i, r.to_i)
end

in_range = []
strong_bot = bots.max_by{|b| b.r}
puts strong_bot.inspect
puts bots.first.inspect

def in_range(a, b)
  d = (a.x - b.x).abs + (a.y - b.y).abs + (a.z - b.z).abs
  d <= a.r
end

bots.each do |bot|
  if in_range(strong_bot, bot)
    in_range << bot
  end
end

puts "Answer: #{in_range.size}"
# 737