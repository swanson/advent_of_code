file = File.open("day23/input.txt").read
# file = 'pos=<10,12,12>, r=2
# pos=<12,14,12>, r=2
# pos=<16,12,12>, r=4
# pos=<14,14,14>, r=6
# pos=<50,50,50>, r=200
# pos=<10,10,10>, r=5'

lines = file.split("\n")

class Bot < Struct.new(:x, :y, :z, :r)
end

bots = []
lines.each do |line|
  x, y, z, r = line.scan(/-*\d+/)
  bots << Bot.new(x.to_i, y.to_i, z.to_i, r.to_i)
end

min_x = bots.min_by{|b| b.x}.x
max_x = bots.max_by{|b| b.x}.x

min_y = bots.min_by{|b| b.y}.y
max_y = bots.max_by{|b| b.y}.y

min_z = bots.min_by{|b| b.z}.z
max_z = bots.max_by{|b| b.z}.z

require "z3"

solver = Z3::Optimize.new
x = Z3.Int("x")
y = Z3.Int("y")
z = Z3.Int("z")

bots_in_range = []
bots.each_with_index do |bot, i|
  bots_in_range << Z3.Int("Bot_#{i}")
end

def in_range(x, y, z, bot)
  Z3.IfThenElse(abs(x - bot.x) + abs(y - bot.y) + abs(z - bot.z) <= bot.r, 1, 0)
end

def abs(x)
  Z3.IfThenElse(x >= 0, x, -x)
end

bots.each_with_index do |bot, i|
  solver.assert bots_in_range[i] == in_range(x, y, z, bot)
end

solver.maximize(Z3.Add(*bots_in_range))
solver.minimize(x + y + z)

raise unless solver.satisfiable?

solver.model.each do |n, v|
  puts "* #{n} = #{v}"
end

# irb(main):001:0> 45591145 + 26525958 + 51239070
# => 123356173