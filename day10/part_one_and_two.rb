f = File.open("day10/input.txt").read
lines = f.split("\n")

enable_print = true

class Point < Struct.new(:pos_x, :pos_y, :vel_x, :vel_y)
  def at(x,y); pos_x == x && pos_y == y; end
  
  def tick!
    self.pos_x += self.vel_x
    self.pos_y += self.vel_y
  end

  def to_s; "#"; end
end

points = []
lines.each do |line|
  px, py, vx, vy = line.scan(/position=<(.+),(.+)> velocity=<(.+),(.+)>/).flatten
  points << Point.new(px.to_i, py.to_i, vx.to_i, vy.to_i)
end

time = 0
close_time = nil
while true do 
  max_y = points.max_by{|p| p.pos_y}.pos_y
  min_y = points.min_by{|p| p.pos_y}.pos_y  

  if max_y - min_y < 10
    close_time = time
    break
  end

  points.map{|p| p.tick!}
  time += 1
end

puts close_time

max_x = points.max_by{|p| p.pos_x}.pos_x
min_x = points.min_by{|p| p.pos_x}.pos_x
max_y = points.max_by{|p| p.pos_y}.pos_y
min_y = points.min_by{|p| p.pos_y}.pos_y

puts "\nt = #{close_time}" if enable_print
(min_y..max_y).each do |y|
  puts "\n" if enable_print
  (min_x..max_x).each do |x|
    p = points.find{|p| p.at(x,y)}
    if p
      print p if enable_print
    else
      print "." if enable_print
    end
  end
end

