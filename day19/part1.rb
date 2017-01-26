require 'pry'
class ElfCounter
  def initialize(num)
    @num = num
  end

  def calculate
    elfs = (1..@num).to_a
    current = 0
    while elfs.size > 1 do
      current = 0 if current > elfs.size - 1
      current += 1
      current = 0 if current > elfs.size - 1
      # puts "killing #{elfs[current]}"
      elfs.delete_at(current)
    end
    elfs.first
  end

  def alt_calc
    1 + 2 * (@num - power_of_two)
  end

  def power_of_two
    bin = "1" + "0" * ((@num).to_s(2).length - 1)
    bin.to_i(2)
  end
end

num = 3001330

counter = ElfCounter.new(num)
puts "With #{num} presents they all go to #{counter.alt_calc} elf"


