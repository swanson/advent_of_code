require "prime"

file = File.open("day19/input.txt").read
# file = '#ip 0
# seti 5 0 1
# seti 6 0 2
# addi 0 1 0
# addr 1 2 3
# setr 1 0 0
# seti 8 0 4
# seti 9 0 5'

lines = file.split("\n")

def print_before(ip, registers)
  puts "\n"
  print "ip=#{ip}\t#{registers.inspect}"
end

def print_after(instruction, registers)
  print "\t#{instruction}\t#{registers.inspect}"
end

def addr(reg, a, b, c)
  dreg = reg.dup  
  dreg[c] = dreg[a] + dreg[b]
  dreg
end

def addi(reg, a, b, c)
  dreg = reg.dup
  dreg[c] = dreg[a] + b
  dreg
end

def mulr(reg, a, b, c)
  dreg = reg.dup  
  dreg[c] = dreg[a] * dreg[b]
  dreg
end

def muli(reg, a, b, c)
  dreg = reg.dup  
  dreg[c] = dreg[a] * b
  dreg
end

def banr(reg, a, b, c)
  dreg = reg.dup  
  dreg[c] = dreg[a] & dreg[b]
  dreg
end

def bani(reg, a, b, c)
  dreg = reg.dup  
  dreg[c] = dreg[a] & b
  dreg
end

def borr(reg, a, b, c)
  dreg = reg.dup  
  dreg[c] = dreg[a] | dreg[b]
  dreg
end

def bori(reg, a, b, c)
  dreg = reg.dup  
  dreg[c] = dreg[a] | b
  dreg
end

def setr(reg, a, b, c)
  dreg = reg.dup
  dreg[c] = dreg[a]
  dreg
end

def seti(reg, a, b, c)
  dreg = reg.dup
  dreg[c] = a
  dreg
end

def gtir(reg, a, b, c)
  dreg = reg.dup
  if a > dreg[b]
    dreg[c] = 1
  else
    dreg[c] = 0
  end
  dreg
end

def gtri(reg, a, b, c)
  dreg = reg.dup
  if dreg[a] > b
    dreg[c] = 1
  else
    dreg[c] = 0
  end
  dreg
end

def gtrr(reg, a, b, c)
  dreg = reg.dup
  if dreg[a] > dreg[b]
    dreg[c] = 1
  else
    dreg[c] = 0
  end
  dreg
end

def eqir(reg, a, b, c)
  dreg = reg.dup
  if a == dreg[b]
    dreg[c] = 1
  else
    dreg[c] = 0
  end
  dreg
end

def eqri(reg, a, b, c)
  dreg = reg.dup
  if dreg[a] == b
    dreg[c] = 1
  else
    dreg[c] = 0
  end
  dreg
end

def eqrr(reg, a, b, c)
  dreg = reg.dup
  if dreg[a] == dreg[b]
    dreg[c] = 1
  else
    dreg[c] = 0
  end
  dreg
end

registers = [1, 0, 0, 0, 0, 0]
ip_reg = lines.shift.chars.last.to_i

cycles = 0

while true
  inst = lines[registers[ip_reg]]
  
  cmd, arg_1, arg_2, arg_3 = inst.split(" ")
  a = arg_1.to_i
  b = arg_2.to_i
  c = arg_3.to_i

  if cycles > 200
    target = registers[3]
    puts target
    sum = 0
    (1..target + 1).each do |i|
      if target % i == 0
        sum += i
      end
    end
    puts sum
    exit
  end

  # print_before(registers[ip_reg], registers)


  registers = send(cmd.to_sym, registers, a, b, c)
  registers[ip_reg] += 1
  # print_after(inst, registers)
  
  if registers[ip_reg] >= lines.length
    puts "\nHalt!"
    print_after(inst, registers)
    exit
  end  

  cycles += 1
end

# Part B: 26671554
