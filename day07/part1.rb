class IpValidator
  def initialize(ip)
    @ip = ip
    extract_nets
  end

  def suports_tls?
    @nets.any? {|net| has_abba?(net) } && !@hypernets.any? {|hypernet| has_abba?(hypernet)}
  end

  private

    def extract_nets
      @nets = []
      @hypernets = []
      word = ''
      hypernet = false
      @ip.chars.each do |char|
        case char
        when '['
          @nets << word
          word = ''
          hypernet = true
          next
        when ']'
          @hypernets << word
          word = ''
          hypernet = false
          next
        else
          word << char
        end
      end
      @nets << word unless word.empty?
      true
    end

    def has_abba?(string)
      0.upto(string.size - 4) do |i|
        s1 = string[i] + string[i + 1]
        s2 = string[i+3] + string[i + 2]
        return true if s1 == s2 && s1[0] != s1[1]
      end
      false
    end
end

class IpListValidator
  def initialize(file)
    @valid = 0
    @lines = File.readlines(file)
  end

  def validate
    @lines.each do |line|
      @valid += 1 if IpValidator.new(line.chomp).suports_tls?
    end
    @valid
  end
end

puts IpListValidator.new('input.txt').validate
