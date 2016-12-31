class Decoder
  def initialize(file)
    @file = file
    @result = 0
  end

  def count
    File.readlines(@file).each do |line|
      @result += process(line)
    end
    @result
  end

  def count_code(letters)
    @counter = {}
    letters.join('').chars do |char|
      if @counter.has_key?(char)
        @counter[char] += 1
      else
        @counter[char] = 1
      end
    end
    code = @counter.sort_by {|k, v| [v, -k.to_s.ord]}.last(5).map {|ar| ar[0]}.join.reverse
    code
  end

  def process(line)
    splitted_line = line.split('-')
    letters = splitted_line[0..-2]
    regexp, value, code = splitted_line[-1].match(/(\d+)\[(.+)\]/).to_a
    if code == count_code(letters)
      value.to_i
    else
      0
    end
  end
end

puts Decoder.new('input.txt').count
