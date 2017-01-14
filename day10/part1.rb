class Bot
  def initialize(num)
    @num = num
    @values = []
  end

  def lower
    @values.min
  end

  def higher
    @values.max
  end

  def ready?
    @values.size == 2
  end

  def give_lower
    @values.delete(lower)
  end

  def give_higher
    @values.delete(higher)
  end

  def receive(value)
    @values << value
  end

end
class Factory
  def initialize
    @bots = {}
    @outputs = {}
    @instructions = []
  end

  def read_instructions(file)
    @instructions = File.readlines(file)
  end

  def run
    while @instructions.any?
    end
  end
end
