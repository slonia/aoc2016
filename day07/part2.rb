require 'pry'
class IpValidator
  def initialize(ip)
    @ip = ip
    extract_nets
  end

  def suports_ssl?
    net_babs = @nets.map { |net| possible_babs(net) }.flatten
    hypernet_babs = @hypernets.map { |net| possible_babs(net, true) }.flatten
    (net_babs & hypernet_babs).any?
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

    def possible_babs(string, revert = false)
      babs = []
      0.upto(string.size - 3) do |i|
        if string[i] == string[i + 2] && string[i] != string[i + 1]
          if revert
            babs << "#{string[i+1]}#{string[i]}#{string[i+1]}"
          else
            babs << "#{string[i]}#{string[i+1]}#{string[i]}"
          end
        end
      end
      babs
    end
end

class IpListValidator
  def initialize(file)
    @valid = 0
    @lines = File.readlines(file)
  end

  def validate
    @lines.each do |line|
      @valid += 1 if IpValidator.new(line.chomp).suports_ssl?
    end
    @valid
  end
end

puts IpListValidator.new('input.txt').validate
