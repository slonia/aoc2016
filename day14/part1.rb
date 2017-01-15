require 'digest'
require 'set'
class KeyGenerator
  def initialize(salt)
    @salt = salt
    @triples = {}
    @fives = {}
    @md5 = Digest::MD5.new
  end

  def find_key(num)
    keys = Set.new
    ind = []
    i = 0
    while ind.size <= num
      hex = @md5.hexdigest(@salt + i.to_s)
      triple = triple[0] if triple = hex.match(/(.)\1\1/)
      five = five[0] if five = hex.match(/(.)\1\1\1\1/)
      if triple
        if @triples.has_key?(triple)
          @triples[triple] << i
        else
          @triples[triple] = [i]
        end
      end
      if five
        five = five[0..2]
        if @fives.has_key?(five)
          @fives[five] << i
        else
          @fives[five] = [i]
        end
      end
      @triples.each do |key, t_pos|
        if @fives.has_key?(key)
          t_pos.each do |pos|
            @fives[key].each do |f_pos|
              if pos + 1000 >= f_pos && f_pos > pos
                keys << key
                ind << pos
                @triples[key].delete(pos)
              end
            end
          end
        end
      end
      i += 1
    end
    puts "Answer: #{ind.to_a.sort[num-1]}"
  end
end

KeyGenerator.new("qzyelonm").find_key(64)
