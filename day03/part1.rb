valid = 0
File.readlines("./input.txt").each do |line|
  numbers = line.scan(/\d+/).map(&:to_i).sort!
  valid += 1 if numbers[0] + numbers[1] > numbers[2]
end
puts valid
