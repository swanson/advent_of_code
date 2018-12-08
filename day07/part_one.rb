file = File.open("day07/input.txt").read
lines = file.split("\n")

class Step < Struct.new(:name, :pre)
  def rdy?(done); (pre - done).empty?; end
end

steps = []
file.scan(/[A-Z] /).uniq.each do |letter|
  steps << Step.new(letter.strip, [])
end



lines.each do |l|
  pre, name = l.scan(/Step (\w) must be finished before step (\w) can begin./).flatten
  step = steps.find{|s| s.name == name}
  step.pre << pre
end

puts steps.inspect

steps = steps.sort_by{|s| s.name}

done = []

while steps.any?
  steps.each do |step|
    if step.rdy?(done)
      done << step.name
      steps.delete(step)
      break;
    end
  end
end

puts done.join
