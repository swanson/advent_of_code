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

guard_sleep = Hash.new(0)

logs.each_with_index do |l, i|
  if l.msg.include?("wakes")
    last_log = logs[i-1]
    guard_sleep[l.guard] += (l.min - last_log.min)
  end
end

sg = guard_sleep.max_by{|k,v| v}.first
sg_minutes = Hash.new(0)

sg_logs = logs.select{|l|l.guard == sg}

sg_logs.each_with_index do |l, i|
  if l.msg.include?("asleep")
    next_log = sg_logs[i+1]
    (l.min..next_log.min).each{|m| sg_minutes[m] += 1}
  end
end

puts sg * sg_minutes.max_by{|k,v| v}.first
