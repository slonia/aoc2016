class DragonCurve
  attr_reader :curve
  def initialize(start, length)
    @curve = start.chars.map(&:to_i)
    @length = length
    generate
  end

  def generate
    while @curve.size < @length
      @curve += [0] + @curve.reverse.map { |a| 1-a}
    end
    @curve = @curve.first(@length)
  end
end

class CheckSum
  def initialize(row)
    @row = row
    @sum = @row
    @calculated = false
  end

  def sum
    while !@calculated
      @sum = @sum.each_slice(2).map do |pair|
        1 - (pair[0] ^ pair[1])
      end
      @calculated = @sum.size.odd?
    end
    @sum.join('')
  end
end
puts CheckSum.new(DragonCurve.new("10011111011011001", 272).curve).sum
