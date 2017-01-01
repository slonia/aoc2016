require 'digest'

class PasswordGenerator
  def initialize(input)
    @prefix = input
    @md5 = Digest::MD5.new
  end

  def password(length = 8)
    @password = Array.new(length)
    i = 0
    found = 0
    while @found != length
      hex = @md5.hexdigest(@prefix + i.to_s)
      if hex.start_with?('00000')
        position = hex[5]
        char = hex[6]
        if !@password[position.to_i] && position.ord >= 48 && position.ord <= (length - 1).to_s.ord
          @password[position.to_i] = char
          found += 1
        end
      end
      i += 1
    end
    @password.join('')
  end
end

input = "uqwqemis"
puts PasswordGenerator.new(input).password
