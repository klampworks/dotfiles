require 'set'

g = File.open(ARGV[0]).read
out = File.open("out.dot", "w+")

forward = Hash.new
backward = Hash.new
attributes = Set.new

g.split("\n").each do |l|

  next if l =~ /}/
  if l =~ /{/ then
    out.puts l
    next
  end

  m = /"([^"]+)"\s*->\s*"([^"]+)"/.match l
  if not m or m.length != 3 then
    out.puts l
    next
  end

  forward[m[1]] = Set.new unless forward[m[1]]
  forward[m[1]].add(m[2])
  backward[m[2]] = Set.new unless backward[m[2]]
  backward[m[2]].add m[1]
end

def process graph, parent, f
    s = Array.new
    s.push parent
    visited = Hash.new(false)

    while true do
      break if s.empty?
      parent = s.pop

      next if visited[parent]
      visited[parent] = true
      next unless graph[parent]

      graph[parent].each do |child|
        f.call parent, child
        s.push child
      end
    end
end

visited_nodes = {}

already_visited = lambda { |src, dst|
  visited_nodes[src] && visited_nodes[src].member?(dst)
}

visit = lambda {|src, dst|
  return true if already_visited.call src, dst
  visited_nodes[src] = Set.new unless visited_nodes[src]
  visited_nodes[src].add(dst)
  false
}

new_notes = []
interesting_node = ARGV[1]
attributes.add "\"#{interesting_node}\" [fillcolor=\"red\"];"

process forward, interesting_node, lambda { |parent, child|
  return if visit.call parent, child
  attributes.add "\"#{child}\" [color=\"red\"];"
  new_notes.push "\"#{parent}\" -> \"#{child}\" [color=\"red\"];"
}

process backward, interesting_node, lambda { |parent, child|
  return if visit.call child, parent
  attributes.add "\"#{child}\" [color=\"green\"];"
  new_notes.push "\"#{child}\" -> \"#{parent}\" [color=\"green\"];"
}

forward.each_key do |n|
  process forward, n, lambda { |parent, child|
    return if visit.call parent, child
    new_notes.push "\"#{parent}\" -> \"#{child}\";"
  }
end

attributes.sort.each do |n|
  out.puts "  #{n}"
end

out.puts ""

# Sorting the output will make graphs more deterministic. i.e.
#  a user can colour different call paths and still have a similar
#  looking graph.
#  On the other hand, not sorting the nodes will make the nodes in the
#  callpath naturally closer together making it easier to understand.
#  Doushio?
#new_notes.sort {|x,y| x.downcase <=> y.downcase}.each do |n|

new_notes.each do |n|
  out.puts "  #{n}"
end

out.puts "}"
