require 'set'

g = File.open("aa.dot").read
out = File.open("out.dot", "w+")

forward = Hash.new
backward = Hash.new
attributes = []

g.split("\n").each do |l|

  next if l =~ /}/
  if l =~ /{/ then
    out.puts l
    next
  end

  m = /"([^"]+)"\s*->\s*"([^"]+)"/.match l
  if not m or m.length != 3 then
    attributes.push l
    next
  end

  forward[m[1]] = Set.new unless forward[m[1]]
  forward[m[1]].add(m[2])
  backward[m[2]] = Set.new unless backward[m[2]]
  backward[m[2]].add m[1]
end

def process graph, parent, myprint
  return unless parent
  return unless graph[parent]
  graph[parent].each do |child|
    myprint.call parent, child
    process graph, child, myprint
  end
end

graph2 = {}

def already_visited? src, dst, graph2
  graph2[src] && graph2[src].member?(dst)
end

def visit src, dst, graph2
  return true if already_visited? src, dst, graph2
  graph2[src] = Set.new unless graph2[src]
  graph2[src].add(dst)
  false
end

new_notes = []
process forward, "g", lambda { |parent, child|
  return if visit parent, child, graph2
  new_notes.push "\"#{parent}\" -> \"#{child}\" [color=\"red\"];"
}

process backward, "g", lambda { |parent, child|
  return if visit child, parent, graph2
  new_notes.push "\"#{child}\" -> \"#{parent}\" [color=\"green\"];"
}

forward.each_key do |n|
  process forward, n, lambda { |parent, child|
    return if visit parent, child, graph2
    new_notes.push "\"#{parent}\" -> \"#{child}\";"
  }
end

attributes.sort.each do |n|
  out.puts "  #{n}"
end

out.puts ""
new_notes.sort.each do |n|
  out.puts "  #{n}"
end
out.puts "}"
