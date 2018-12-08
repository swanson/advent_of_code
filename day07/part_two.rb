file = File.open("day07/input.txt").read
lines = file.split("\n")

class Step
  attr_accessor :name, :pre, :work

  def initialize(n, p)
    @name = n
    @pre = p
    @work = 60 + (name.ord - 64)
  end

  def rdy?(done); (@pre - done).empty?; end
  def work!; @work -= 1; end
  def done?; @work < 1; end
end

class Worker < Struct.new(:id, :queue)
  def tick!
    return nil if free?

    step = queue.first
    step.work!

    if step.done?
      queue.delete(step)
      return step
    end
  end

  def free?; queue.empty?; end
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

steps = steps.sort_by{|s| s.name}
puts steps.inspect

step_count = steps.size
done = []
workers = []
5.times {|i| workers << Worker.new(i, []) }

ticks = 0

while done.size != step_count
  rdy_steps = steps.select{|s| s.rdy?(done)}
  rdy_steps.each do |step|
    puts "Step ready: #{step.name}"
    free_worker = workers.find{|w| w.free?}
    
    if free_worker
      puts "Worker #{free_worker.id} starting job"
      free_worker.queue << step
      steps.delete(step)
    else  
      puts "No free workers. Waiting..."
    end
  end

  workers.each do |w|
    step_done = w.tick!
    if step_done
      puts "Worker #{w.id} finished: #{step_done.name}, Tick: #{ticks}"
      done << step_done.name
    end
  end

  ticks += 1
end

puts done.join
puts "\n\nTotal: #{ticks}"
