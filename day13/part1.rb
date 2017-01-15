require 'set'
require 'pry'
class Maze
  INF = 1_000_000
  def initialize(size)
    @size = size
    @maze = Array.new(size) { Array.new(size, 0)}
    @source_x, @source_y, @dest_x, @dest_y = 1, 1, 1, 1
  end

  # A* implementation
  def goto(dest_x, dest_y)
    @dest_x = dest_x
    @dest_y = dest_y
    dest_node = [@dest_x, @dest_y]
    closed = Set.new
    open = Set.new
    open << [@source_x, @source_y]
    gscores = init_gscores
    fscores = init_fscores
    from = {}
    while open.any?
      current = lowest_score(fscores, open)
      return reconstruct(from, current) if current == dest_node
      open.delete(current)
      closed << current
      n = get_neighbors(current)
      n.each do |neighbor|
        next if closed.include?(neighbor)
        tent = gscores[current] + 1
        if !open.include?(neighbor)
          open << neighbor
        elsif tent >= gscores[neighbor]
          next
        end
        from[neighbor] = current
        gscores[neighbor] = tent
        fscores[neighbor] = tent + euristic(neighbor)
      end
    end
  end

  private

    def reconstruct(from, current)
      total = []
      total << current
      while from.has_key?(current)
        current = from[current]
        total << current
      end
      # total.reverse.each do |row|
      #   puts row.join(', ')
      # end
      puts total.size - 1
    end

    def puts_gscores(gscores)
      0.upto(@size).each do |j|
        a = ""
        0.upto(@size).each do |i|
          a << "#{gscores[[i,j]]} "
        end
        puts a
      end
      puts "======================="
    end

    def is_wall?(node)

      i = node[1]
      j = node[0]
      n = @size + i*i + 3*i + 2*i*j + j + j*j
      res = n.to_s(2).chars.inject(0) { |sum, a| sum += a.to_i}.odd?
      # puts "is wall? #{i}, #{j}, #{res}"
      res
    end

    def get_neighbors(node)
      x = node[1]
      y = node[0]
      neighbors = []
      neighbors << [y, x+1] if x < @size - 2 && !is_wall?([y, x+1])
      neighbors << [y, x-1] if x > 0 && !is_wall?([y, x-1])
      neighbors << [y+1, x] if y < @size - 2 && !is_wall?([y+1, x])
      neighbors << [y-1, x] if y > 0 && !is_wall?([y-1, x])
      neighbors
    end

    def lowest_score(scores, open)
      min = INF
      node = [@source_x, @source_y]
      scores.each do |new_node, score|
        if score < min && open.include?(new_node)
          min = score
          node = new_node
        end
      end
      node
    end

    def init_gscores
      scores = {}
      0.upto(@size) do |j|
        0.upto(@size) do |i|
          if i == @source_y && j == @source_x
            scores[[i, j]] = 0
          else
            scores[[i, j]] = INF
          end
        end
      end
      scores
    end

    def init_fscores
      scores = {}
      0.upto(@size) do |j|
        0.upto(@size) do |i|
          if i == @source_y && j == @source_x
            scores[[i, j]] = euristic([i, j])
          else
            scores[[i, j]] = INF
          end
        end
      end
      scores
    end

    def euristic(node)
      i = node[1]
      j = node[0]
      (@dest_x - j).abs + (@dest_y - i).abs
    end
end

Maze.new(1350).goto(39, 31)
