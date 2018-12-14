

def print_world(elf_1, elf_2, scores)
  scores.each_with_index do |s, i|
    if i == elf_1
      print "(" + s.to_s + ")"
    elsif i == elf_2
      print "[" + s.to_s + "]"
    else
      print " " + s.to_s + " "
    end
  end
  puts "\n"
end

def make_recipes(elf_1, elf_2, scores)
  elf_1_current = scores[elf_1]
  elf_2_current = scores[elf_2]

  sum = elf_1_current + elf_2_current
  sum.to_s.chars.map{|c| c.to_i}.each do |r|
    scores.push(r)
  end

  elf_1 = (elf_1 + elf_1_current + 1) % (scores.length)
  elf_2 = (elf_2 + elf_2_current + 1) % (scores.length)

  [elf_1, elf_2]
end

def run(puzzle)
  elf_1 = 0
  elf_2 = 1

  scores = [3, 7]
  total_recipes = 0

  answer_start = 0

  while true
    # print_world(elf_1, elf_2, scores)
    delta = scores.length
    elf_1, elf_2 = make_recipes(elf_1, elf_2, scores)
    delta = scores.length - delta
    total_recipes += delta

    if total_recipes == puzzle
      answer_start = scores.length - 1
    end

    if total_recipes >= (puzzle + 10)
      answer = scores[answer_start-1..answer_start+8].join("")
      return answer
    end
  end
end

def assert(input, expected)
  actual = run(input)
  raise "Wrong: f(#{input}) = #{actual}, not #{expected}" unless  actual == expected
  puts "Correct: f(#{input})"
end

assert 5, "0124515891"
assert 9, "5158916779"
assert 18, "9251071085"
assert 2018, "5941429882"

input = 236021
puts "Solving #{input}"
puts run(input)