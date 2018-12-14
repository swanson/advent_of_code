

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

def make_recipes(elf_1, elf_2, scores, puzzle)
  elf_1_current = scores[elf_1]
  elf_2_current = scores[elf_2]

  sum = elf_1_current + elf_2_current
  sum.to_s.chars.map{|c| c.to_i}.each do |r|
    scores.push(r)
    if $last_chars.length < puzzle.length
      $last_chars.push(r)
    else
      $last_chars.shift
      $last_chars.push(r)
    end

    if $last_chars.join("").include? puzzle
      $answer = true
    end
  end

  elf_1 = (elf_1 + elf_1_current + 1) % (scores.length)
  elf_2 = (elf_2 + elf_2_current + 1) % (scores.length)

  [elf_1, elf_2]
end

def run(puzzle)
  $last_chars = []
  $answer = nil
  elf_1 = 0
  elf_2 = 1

  scores = [3, 7]

  last_recipe_count = 0

  while true
    # print_world(elf_1, elf_2, scores)
    
    last_recipe_count = scores.length

    elf_1, elf_2 = make_recipes(elf_1, elf_2, scores, puzzle)

    # if $last_chars.join("").include? puzzle
    #   puts "Found answer"
    #   answer = last_recipe_count - puzzle.length + 1
    #   return answer
    # end

    return last_recipe_count - puzzle.length + 1 if $answer

    # if scores.length % 10000 == 0
    #   puts "Recipes: #{scores.length}"
    # end
  end
end

def assert(input, expected)
  actual = run(input)
  raise "Wrong: f(#{input}) = #{actual}, not #{expected}" unless  (actual - expected) <= 1
  puts "Correct: f(#{input}), Answer: #{actual} or #{actual + 1}"
end

assert "51589", 9
assert "01245", 5
assert "92510", 18
assert "59414", 2018

input = "236021"
puts "Solving #{input}"
puts run(input)