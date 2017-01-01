require 'digest'

class PasswordGenerator
  def initialize(input)
    @prefix = input
    @md5 = Digest::MD5.new
  end

  def password(length = 8)
    @password = ''
    i = 0
    while @password.size != length
      hex = @md5.hexdigest(@prefix + i.to_s)
      if hex.start_with?('00000')
        @password << hex[5]
      end
      i += 1
    end
    @password
  end
end

input = "uqwqemis"
puts PasswordGenerator.new(input).password
