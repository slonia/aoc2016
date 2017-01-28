class IpCounter
  def initialize(file)
    @ranges = read(file)
    @initr= @ranges.dup
    join_ranges
  end

  def first_ip
    start = 0
    @ranges.each do |range|
      if start < range.first
        return start
        break
      else
        start = range.last + 1
      end
    end
  end

  private

  def read(file)
    File.readlines(file).map do |line|
      from, to = line.split("-").map(&:to_i)
      (from..to)
    end.sort_by {|r| [r.first, r.last]}
  end

  def join_ranges
    joined = true
    while joined
      joined = false
      0.upto(@ranges.size-2).each do |i|
        if @ranges[i].last + 1 >= @ranges[i+1].first
          last = [@ranges[i].last, @ranges[i+1].last].max
          @ranges[i] = (@ranges[i].first..last)
          @ranges.delete_at(i+1)
          joined = true
          break
        end
      end
    end
  end
end

puts IpCounter.new('input.txt').first_ip
