file = File.open("day08/input.txt").read
# file = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
# 2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
# A----------------------------------
#     B----------- C-----------
#                      D-----
numbers = file.split(" ").map(&:to_i)
print_out = false
total = 0
metadata = []

while numbers.any?
  puts numbers.inspect if print_out
  dying_node_idx = numbers.index(0)
  if !dying_node_idx.nil?
    parent_node_idx = dying_node_idx - 2
    numbers[parent_node_idx] -= 1 if parent_node_idx >= 0

    dying_meta_count = numbers[dying_node_idx + 1]
    dying_meta_count.times do
      foo = numbers.delete_at(dying_node_idx + 2)
      puts "Adding metadata: #{foo}" if print_out
      metadata << foo
    end
    numbers.delete_at(dying_node_idx + 1)
    numbers.delete_at(dying_node_idx)
  else
    puts numbers.inspect
    exit
  end
end

metadata.flatten!
puts metadata.inspect if print_out

metadata.each{|m| total += m}
puts "Total: #{total}"