file = File.open("day08/input.txt").read
#file = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
# 2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
# A ----------------------------------
#     B ----------- D-----------
#                      C-----
numbers = file.split(" ").map(&:to_i)
$numbers = numbers
$position = 0
$node_name = "A"

class Node < Struct.new(:name, :metadata, :children)
  def value
    return metadata.inject(:+) if children.empty?

    total = 0
    metadata.each do |m|
      if m <= children.length
        total += children[m - 1].value
      end
    end
    total
  end
end

def next_number
  $position += 1
  $numbers[$position - 1]
end

def build_node
  child_count = next_number
  meta_count = next_number
  
  node = Node.new($node_name, [], [])
  $node_name = $node_name.next
  
  child_count.times do
    node.children << build_node
  end
  
  meta_count.times do
    node.metadata << next_number
  end

  node
end

root = build_node
puts root.inspect
puts root.value