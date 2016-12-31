require 'set'

input = %w(L4 L3 R1 L4 R2 R2 L1 L2 R1 R1 L3 R5 L2 R5 L4 L3 R2 R2 L5 L1 R4 L1 R3 L3 R5 R2 L5 R2 R1 R1 L5 R1 L3 L2 L5 R4 R4 L2 L1 L1 R1 R1 L185 R4 L1 L1 R5 R1 L1 L3 L2 L1 R2 R2 R2 L1 L1 R4 R5 R53 L1 R1
R78 R3 R4 L1 R5 L1 L4 R3 R3 L3 L3 R191 R4 R1 L4 L1 R3 L1 L2 R3 R2 R4 R5 R5 L3 L5 R2 R3 L1 L1 L3 R1 R4 R1 R3 R4 R4 R4 R5 R2 L5 R1 R2 R5 L3 L4 R1 L5 R1 L4 L3 R5 R5 L3 L4 L4 R2 R2 L5 R3 R1 R2 R5 L5
L3 R4 L5 R5 L3 R1 L1 R4 R4 L3 R2 R5 R1 R2 L1 R4 R1 L3 L3 L5 R2 R5 L1 L4 R3 R3 L3 R2 L5 R1 R3 L3 R2 L1 R4 R3 L4 R5 L2 L2 R5 R1 R2 L4 L4 L5 R3 L4)

# input = %w(R8 R4 R4 R8)
class Direction
  DIRECTIONS = [:west, :south, :east, :north]

  attr_reader :position
  def initialize
    @position = :north
  end

  def turn_left
    @position = DIRECTIONS[current_index - 1]
  end

  def turn_right
    index = current_index + 1
    index = 0 if index == 4
    @position = DIRECTIONS[index]
  end

  private

    def current_index
      DIRECTIONS.index(@position)
    end
end

class Travel
  def initialize(input)
    @route = input
    @direction = Direction.new
    @x = 0
    @y = 0
    @visited = Set.new
  end

  def go
    @visited << [0, 0]
    @route.each do |route|
      direction, length = route[0], route[1..-1].to_i
      direction == 'L' ? @direction.turn_left : @direction.turn_right
      puts @direction.position
      case @direction.position
      when :north
        goto(@x, @y + length)
      when :south
        goto(@x, @y - length)
      when :west
        goto(@x - length, @y)
      when :east
        goto(@x + length, @y)
      end
    end
    @x.abs + @y.abs
  end

  def goto(x, y)
    if y == @y
      if @x > x
        (@x - 1).downto(x) do |i|
          visit(i, @y)
        end
      else
        (@x + 1).upto(x) do |i|
          visit(i, @y)
        end
      end
    else
      if @y > y
        (@y - 1).downto(y) do |i|
          visit(@x, i)
        end
      else
        (@y + 1).upto(y) do |i|
          visit(@x, i)
        end
      end
    end
  end

  def visit(x, y)
    @x = x
    @y = y
    # puts "#{x}, #{y}"
    if @visited.include?([x, y])
      puts "ALready visited. Distance is #{x.abs + y.abs}"
    else
      @visited << [x, y]
    end
  end
end

puts Travel.new(input).go
