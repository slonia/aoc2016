inv = []
def valid?(vertices)
  vertices.sort!
  vertices[0] + vertices[1] > vertices[2]
end

valid = 0
File.readlines("./input.txt").each_slice(3) do |line|
  numbers1 = line[0].scan(/\d+/).map(&:to_i)
  numbers2 = line[1].scan(/\d+/).map(&:to_i)
  numbers3 = line[2].scan(/\d+/).map(&:to_i)
  0.upto(2).each do |i|
    if valid?([numbers1[i], numbers2[i], numbers3[i]])
      valid += 1
    else
      inv << [numbers1[i], numbers2[i], numbers3[i]]
    end
  end
end

puts valid
