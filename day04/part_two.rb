file = File.open("day04/sorted_input.txt")
lines = file.read.split("\n")

class Log < Struct.new(:date, :min, :msg, :guard); end;

logs = []
last_guard = nil

lines.each do |l|
  parts = l.gsub!("[", "").gsub!("]", "").split(" ")
  date = parts[0]
  min = parts[1].split(":").last.to_i
  msg = parts[2..-1].join(" ")

  guard = l.scan(/#(\d*)/).flatten.first
  unless guard.nil?
    last_guard = guard
  end

  logs << Log.new(date, min, msg, last_guard.to_i)
end

all_guards = logs.map{|l| l.guard}.uniq
guard_minutes = Hash.new(0)
all_guards.each do |g|
  guard_minutes[g] = Hash.new(0)
end

logs.each_with_index do |l, i|
  if l.msg.include?("asleep")
    next_log = logs[i+1]
    (l.min..next_log.min).each do |m|
      guard_minutes[l.guard][m] += 1
    end
  end
end

max = 0
max_guard = -1
max_minute = -1
guard_minutes.each do |k, minutes|
  minutes.each do |k2, s|
    if s > max
      max = s
      max_minute = k2
      max_guard = k
    end
  end
end

puts max_minute, max_guard
puts max_minute * max_guard

# puts sg * sg_minutes.max_by{|k,v| v}.first
