require 'pry'
class Computer
  CPY = /cpy (?<from>\d+|\w) (?<to>\w)/
  INC = /inc (?<register>\w)/
  DEC = /dec (?<register>\w)/
  JNZ = /jnz (?<register>\w) (?<i>-?\d+)/

  def initialize(file)
    @registers = {
      "a" => 0,
      "b" => 0,
      "c" => 1,
      "d" => 0,
    }
    @instructions = File.readlines(file).map(&:chomp)
  end

  def run
    i = 0
    while i < @instructions.size
      i += execute(@instructions[i])
    end
    puts @registers
  end

  def execute(instruction)
    if match = instruction.match(CPY)
      if ('a'..'d').include?(match[:from])
        @registers[match[:to]] = @registers[match[:from]]
      else
        @registers[match[:to]] = match[:from].to_i
      end
      1
    elsif match = instruction.match(INC)
      @registers[match[:register]] += 1
      1
    elsif match = instruction.match(DEC)
      @registers[match[:register]] -= 1
      1
    elsif match = instruction.match(JNZ)
      if @registers[match[:register]] == 0
        1
      else
        match[:i].to_i
      end
    end
  end
end

Computer.new('input.txt').run
