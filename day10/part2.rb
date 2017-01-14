require 'pry'
class Bot
  attr_reader :values
  def initialize(n)
    @n = n
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
  VALUE = /value (?<value>\d+) goes to bot (?<id>\d+)/
  GIVE = /bot (?<id>\d+) gives low to (?<low_to>output|bot) (?<low_n>\d+) and high to (?<high_to>output|bot) (?<high_n>\d+)/
  def initialize(file)
    @bots = {}
    @outputs = {}
    @instructions = File.readlines(file)
  end

  def run
    i = 0
    while @instructions.any?
      @instructions.each do |instruction|
        run = run_instruction(instruction)
        @instructions.delete(instruction) if run
      end
    end
    self
  end

  def output
    @outputs[0] * @outputs[1] * @outputs[2]
  end

  def run_instruction(instruction)
    instruction = instruction.chomp
    if match = instruction.match(VALUE)
      id = match[:id].to_i
      value = match[:value].to_i
      @bots[id] ||= Bot.new(id)
      @bots[id].receive(value)
      true
    elsif match = instruction.match(GIVE)
      id, low_to, low_n, high_to, high_n = match.to_a.last(5)
      id = id.to_i
      low_n = low_n.to_i
      high_n = high_n.to_i
      @bots[id] ||= Bot.new(id)
      bot = @bots[id]
      if bot.ready?
        if low_to == 'bot'
          @bots[low_n] ||= Bot.new(low_n)
          @bots[low_n].receive(bot.give_lower)
        else
          @outputs[low_n] = bot.give_lower
        end
        if high_to == 'bot'
          @bots[high_n] ||= Bot.new(high_n)
          @bots[high_n].receive(bot.give_higher)
        else
          @outputs[high_n] = bot.give_higher
        end
        true
      else
        false
      end
    end
  end
end

puts Factory.new('input.txt').run.output
