class Maze
  def initialize(row, length)
    @maze = Array.new(length) { Array.new(row.size, 0) }
    @maze[0] = row
    @length = length
    @width = row.size
    generate
  end

  def output
    0.upto(@length-1).each do |i|
      row = []
      0.upto(@width-1).each do |j|
        row << @maze[i][j] == 1 ? '*' : '^'
      end
      puts row.join('')
    end
  end

  def safe_tiles
    @length * @width - @maze.map {|a| a.inject(:+)}.inject(:+)
  end

  private

    def generate
      1.upto(@length-1).each do |i|
        0.upto(@width-1).each do |j|
          if j == 0
            left = 0
            right = @maze[i-1][j+1]
          elsif j == @width-1
            right = 0
            left = @maze[i-1][j-1]
          else
            left = @maze[i-1][j-1]
            right = @maze[i-1][j+1]
          end
          center = @maze[i-1][j]
          @maze[i][j] = if  (center + right == 2 && left == 0) || (center + left == 2 && right == 0) || (left == 1 && right + center == 0) || (right == 1 && left + center == 0)
            1
          else
            0
          end
        end
      end
    end
end

input = '.^^^^^.^^^..^^^^^...^.^..^^^.^^....^.^...^^^...^^^^..^...^...^^.^.^.......^..^^...^.^.^^..^^^^^...^.'
puts Maze.new(input.chars.map {|a| a == '^' ? 1 : 0}, 400_000).safe_tiles
