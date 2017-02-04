require 'pry'
class Computer
  CPY = /cpy (?<from>\w|-?\d+) (?<to>\w)/
  INC = /inc (?<register>\w)/
  DEC = /dec (?<register>\w)/
  JNZ = /jnz (?<cond>\w|-?\d+) (?<i>\w|-?\d+)/
  TGL = /tgl (?<i>\w|-?\d+)/

  def initialize(file)
    @registers = {
      "a" => 7,
      "b" => 0,
      "c" => 0,
      "d" => 0,
    }
    @instructions = File.readlines(file).map(&:chomp)
  end

  def run
    i = 0
    processed = 0
    while i < @instructions.size
      i += execute(i)
      # puts @instructions.join(", ")
    end
    puts @registers
  end

  def execute(i)
    instruction = @instructions[i]
    # puts instruction
    if match = instruction.match(CPY)
      # puts 'CPY'
      if ('a'..'d').include?(match[:from])
        @registers[match[:to]] = @registers[match[:from]]
      else
        @registers[match[:to]] = match[:from].to_i
      end
      1
    elsif match = instruction.match(INC)
      # puts 'INC'
      @registers[match[:register]] += 1
      1
    elsif match = instruction.match(DEC)
      # puts 'DEC'
      @registers[match[:register]] -= 1
      1
    elsif match = instruction.match(JNZ)
      # puts 'JNZ'
      value = match[:cond]
      value = @registers[value] if ('a'..'d').include?(value)
      if value.to_i == 0
        1
      else
        shift = match[:i]
        shift = @registers[shift] if ('a'..'d').include?(shift)
        shift.to_i
      end
    elsif match = instruction.match(TGL)
      # puts 'TGL'
      shift = match[:i]
      shift = @registers[shift] if ('a'..'d').include?(shift)
      toggle(i + shift)
      1
    else
      # puts 'NOT PROCESSABLE'
      1
    end
  end

  def toggle(i)
    return if i >= @instructions.size
    instruction = @instructions[i]
    if instruction.match(INC)
      @instructions[i] = instruction.gsub("inc", "dec")
    elsif instruction.match(TGL) || instruction.match(DEC)
      @instructions[i][0..2] = "inc"
    elsif instruction.match(JNZ)
      @instructions[i] = instruction.gsub('jnz', 'cpy')
    elsif instruction.match(CPY)
      @instructions[i] = instruction.gsub('cpy', 'jnz')
    end
  end
end

Computer.new('input.txt').run
