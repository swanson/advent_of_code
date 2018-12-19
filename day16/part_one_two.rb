file = File.open("day16/input.txt").read
# file = 'Before: [3, 2, 1, 1]
# 9 2 1 2
# After:  [3, 2, 2, 1]
# '
lines = file.split("\n")

class Example
  attr_reader :before, :after, :inst
  def initialize(before, after, inst)
    @before = before
    @after = after
    @inst = inst
  end

  def opcode; @inst.first; end
  def val_a; @inst[1]; end
  def val_b; @inst[2]; end
  def val_c; @inst.last; end;
  def reg_a; @before[val_a]; end;
  def reg_b; @before[val_b]; end;
end

examples = []
lines.each_slice(4) do |a, b, c, _|
  reg_before = a.scan(/\d/).map{|b| b.to_i}
  inst = b.split(" ").map{|b| b.to_i}
  reg_after = c.scan(/\d/).map{|b| b.to_i}

  examples << Example.new(reg_before, reg_after, inst)
end

examples_by_opcode = Hash.new
examples.each do |e|
  key = e.opcode
  if !examples_by_opcode.has_key? key
    examples_by_opcode[key] = []
  end

  examples_by_opcode[key] << e
end

def test_opcode(code, examples)
  examples.all?{|e| correct(code, e)}
end

def addr(e)
  actual = e.before.dup
  actual[e.val_c] = e.reg_a + e.reg_b
  actual
end

def addi(e)
  actual = e.before.dup
  actual[e.val_c] = e.reg_a + e.val_b
  actual
end

def mulr(e)
  actual = e.before.dup
  actual[e.val_c] = e.reg_a * e.reg_b
  actual
end

def muli(e)
  actual = e.before.dup
  actual[e.val_c] = e.reg_a * e.val_b
  actual
end

def banr(e)
  actual = e.before.dup
  actual[e.val_c] = e.reg_a & e.reg_b
  actual
end

def bani(e)
  actual = e.before.dup
  actual[e.val_c] = e.reg_a & e.val_b
  actual
end

def borr(e)
  actual = e.before.dup
  actual[e.val_c] = e.reg_a | e.reg_b
  actual
end

def bori(e)
  actual = e.before.dup
  actual[e.val_c] = e.reg_a | e.val_b
  actual
end

def setr(e)
  actual = e.before.dup
  actual[e.val_c] = e.reg_a
  actual
end

def seti(e)
  actual = e.before.dup
  actual[e.val_c] = e.val_a
  actual
end

def gtir(e)
  actual = e.before.dup
  if e.val_a > e.reg_b
    actual[e.val_c] = 1
  else
    actual[e.val_c] = 0
  end
  actual
end

def gtri(e)
  actual = e.before.dup
  if e.reg_a > e.val_b
    actual[e.val_c] = 1
  else
    actual[e.val_c] = 0
  end
  actual
end

def gtrr(e)
  actual = e.before.dup
  if e.reg_a > e.reg_b
    actual[e.val_c] = 1
  else
    actual[e.val_c] = 0
  end
  actual
end

def eqir(e)
  actual = e.before.dup
  if e.val_a == e.reg_b
    actual[e.val_c] = 1
  else
    actual[e.val_c] = 0
  end
  actual
end

def eqri(e)
  actual = e.before.dup
  if e.reg_a == e.val_b
    actual[e.val_c] = 1
  else
    actual[e.val_c] = 0
  end
  actual
end

def eqrr(e)
  actual = e.before.dup
  if e.reg_a == e.reg_b
    actual[e.val_c] = 1
  else
    actual[e.val_c] = 0
  end
  actual
end

def correct(code, e)
  case code
  when :addr
    return addr(e) == e.after
  when :addi
    return addi(e) == e.after
  when :mulr
    return mulr(e) == e.after
  when :muli
    return muli(e) == e.after
  when :banr
    return banr(e) == e.after
  when :bani
    return bani(e) == e.after
  when :borr
    return borr(e) == e.after
  when :bori
    return bori(e) == e.after
  when :setr
    return setr(e) == e.after
  when :seti
    return seti(e) == e.after
  when :gtir
    return gtir(e) == e.after
  when :gtri
    return gtri(e) == e.after
  when :gtrr
    return gtrr(e) == e.after
  when :eqir
    return eqir(e) == e.after
  when :eqri
    return eqri(e) == e.after
  when :eqrr
    return eqrr(e) == e.after
  else
    return false
  end
end

all_codes = [
  :addr, :addi, :mulr, :muli, :banr, :bani, :borr, :bori,
  :setr, :seti, :gtir, :gtri, :gtrr, :eqir, :eqri, :eqrr
]

three_or_more = 0
examples.each do |e|
  possible_opcodes = []
  all_codes.each do |c|
    possible_opcodes << c if correct(c, e)
  end

  three_or_more += 1 if possible_opcodes.length > 2
end

puts "Answer - Part A: #{three_or_more}"
raise unless three_or_more == 531

code_map = Hash.new
(0..15).each do |c|
  code_map[c] = []
end

examples_by_opcode.sort_by{|k,v| k}.each do |op, examples|  
  possible_opcodes = []
  all_codes.each do |c|
    possible_opcodes << c if test_opcode(c, examples)
  end

  code_map[op] << possible_opcodes
  code_map[op].flatten!
end

10.times do
  code_map.each do |c, matches|
    if matches.length == 1
      code_map[c] = [matches.first]
      code_map.each do |c2, v|
        if c2 != c
          v.delete(matches.first)
        end
      end
    end
  end
end

code_map.each do |k, v|
  code_map[k] = v.first
end

file2 = File.open("day16/input_2.txt").read
lines = file2.split("\n")

registers = [0,0,0,0]

lines.each do |inst|
  e = Example.new(registers, nil, inst.split(" ").map{|i| i.to_i})
  registers = send(code_map[e.opcode], e)
end

puts "Answer - Part B: #{registers.first}"
raise unless registers.first == 649
