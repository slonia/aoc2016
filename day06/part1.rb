class SignalCorrector
  def initialize(input)
    @letters = {}
    File.readlines(input).each do |line|
      line.chomp.chars.each_with_index do |char, i|
        @letters[i] = {} unless @letters[i]
        if @letters[i].has_key?(char)
          @letters[i][char] += 1
        else
          @letters[i][char] = 1
        end
      end
    end

  end

  def password
    @letters.map do |k, v|
      v.sort_by {|ch, n| n }.last.first
    end.join('')
  end
end
puts SignalCorrector.new('input.txt').password
