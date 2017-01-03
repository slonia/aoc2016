class Field
  RECT = /rect (?<w>\d+)x(?<h>\d+)/
  ROTATE_ROW = /rotate row y=(?<row>\d+) by (?<offset>\d+)/
  ROTATE_COL = /rotate column x=(?<col>\d+) by (?<offset>\d+)/
  def initialize(file)
    @file = file
    @w = 50
    @h = 6
    @field = Array.new(@h) { Array.new(@w, 0) }
  end

  def process
    File.readlines(@file).each do |line|
      exec_command(line.chomp)
    end
    self
  end

  def enabled
    print_field
    @field.map {|a| a.inject(:+) }.inject(:+)
  end

  private

    def exec_command(command)
      if result = command.match(RECT)
        light_rect(result[:w].to_i, result[:h].to_i)
      elsif result = command.match(ROTATE_ROW)
        rotate_row(result[:row].to_i, result[:offset].to_i)
      elsif result = command.match(ROTATE_COL)
        rotate_col(result[:col].to_i, result[:offset].to_i)
      end
    end

    def light_rect(w, h)
      # puts "rect #{w} #{h}"
      0.upto(h-1) do |i|
        0.upto(w-1) do |j|
          @field[i][j] = 1
        end
      end
    end

    def rotate_row(row, offset)
      # puts "row #{offset}"
      @field[row] = @field[row].rotate(-offset)
    end

    def rotate_col(col_n, offset)
      # puts "col #{col_n} #{offset}"
      col = @field.map{|a| a[col_n]}
      col = col.rotate(-offset)
      0.upto(@h-1).each do |i|
        @field[i][col_n] = col[i]
      end
    end

    def print_field
      puts "###########################"
      0.upto(@h-1).each do |i|
        a = 0.upto(@w-1).map do |j|
          @field[i][j] == 1 ? '*' : ' '
        end.join(' ')
        puts a
      end
    end
end


puts Field.new('input.txt').process.enabled
