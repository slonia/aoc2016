require 'set'
Disc = Struct.new(:positions, :start) do
  def pos_at(time)
    (start + time) % positions
  end
end

class DiscSculpture
  FORMAT = /Disc #(?<id>\d+) has (?<positions>\d+) positions; at time=0, it is at position (?<start>\d+)\./
  def initialize(file)
    @discs = []
    File.readlines(file).each do |line|
      data = line.chomp.match(FORMAT)
      @discs << Disc.new(data[:positions].to_i, data[:start].to_i)
    end
    add_default_disc
  end

  def solve
    t = 1
    loop do
      pos = Set.new
      @discs.each_with_index do |disc, i|
        pos << disc.pos_at(t + i)
      end
      break if pos.size == 1
      t += 1
      add_default_disc
    end
    t -= 1
  end

  private

    def add_default_disc
      @discs << Disc.new(11, 0)
    end
end

puts DiscSculpture.new('input.txt').solve
