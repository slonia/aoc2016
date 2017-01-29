require 'pry'
class Scrambler
  SWAP_POSITION = /swap position (\d+) with position (\d+)/
  SWAP_LETTER = /swap letter (\w) with letter (\w)/
  ROTATE_BY_DIRECTION = /rotate (left|right) (\d+) steps?/
  ROTATE_BY_LETTER = /rotate based on position of letter (\w)/
  REVERSE_POSITIONS = /reverse positions (\d+) through (\d+)/
  MOVE_POSITION = /move position (\d+) to position (\d+)/

  def initialize(start, file)
    @instructions = File.readlines(file)
    @start = start.split('')
  end

  def scramble!
    @instructions.each do |instruction|
      instruction = instruction.chomp
      if SWAP_POSITION.match(instruction)
        swap_position($1.to_i, $2.to_i)
      elsif SWAP_LETTER.match(instruction)
        swap_letter($1, $2)
      elsif ROTATE_BY_DIRECTION.match(instruction)
        rotate_by_direction($1, $2.to_i)
      elsif ROTATE_BY_LETTER.match(instruction)
        rotate_by_letter($1)
      elsif REVERSE_POSITIONS.match(instruction)
        reverse_positions($1.to_i, $2.to_i)
      elsif MOVE_POSITION.match(instruction)
        move_position($1.to_i, $2.to_i)
      end
      # puts @start.join('')
    end
    @start.join('')
  end

  def rotate_by_letter(x)
    # puts "rotate by letter #{x}"
    rotate = @start.index(x) + 1
    rotate += 1 if rotate >= 5
    rotate_by_direction('right', rotate)
  end

  def move_position(x, y)
    # puts "move position #{x}, #{y}"
    @start.insert(y, @start.delete_at(x))
  end

  def reverse_positions(x, y)
    # puts "reverse positions #{x}, #{y}"
    @start[x..y] = @start[x..y].reverse
  end

  def rotate_by_direction(dir, x)
    # puts "rotate #{dir} by #{x}"
    if dir == 'left'
      @start = @start.rotate(x)
    else
      @start = @start.rotate(-x)
    end
  end

  def swap_position(x, y)
    # puts "swap #{x}, #{y}"
    letter = @start[x]
    @start[x] = @start[y]
    @start[y] = letter
  end

  def swap_letter(x, y)
    # puts "swap letters #{x} with #{y}"
    @start.each_with_index do |l, i|
      if l == x
        @start[i] = y
      elsif l == y
        @start[i] = x
      end
    end
  end

end

puts Scrambler.new('abcdefgh', 'input.txt').scramble!
