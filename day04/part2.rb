class Decoder
  def initialize(file)
    @file = file
    @result = 0
  end

  def run
    File.readlines(@file).each do |line|
      process(line)
    end
    nil
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
      shift_string(letters.join(' ').downcase, value.to_i)
    end
    nil
  end

  def shift_string(string, num)
    out = ""
    string.chars.each do |ch|
      out << rotate(ch, num)
    end
    if out.match("north")
      puts out
      puts num
    end
  end

  def rotate(char, num)
    return ' ' if char == '-' || char == ' '
    num = num % 26
    ord = char.ord + num
    ord -= 26 if ord > 122
    ord.chr
  end
end

puts Decoder.new('input.txt').run
