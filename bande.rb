class Keypad
  attr_reader :key_history, :code_bank
  def initialize(mode_keys,code_length)
    @key_history = []
    @code_bank = Array.new(10**code_length, 0)
    @mode_keys = mode_keys
    @code_length = code_length
  end

  def press(digit = get_key_press)
    @key_history << digit
    if @key_history.size > @code_length && @mode_keys.include?(@key_history[-1])
      @code_bank[@key_history[(-1 - @code_length)..-2].join("").to_i] = 1
    end
  end

  def all_codes_entered?
    !@code_bank.include?(0)
  end

  def get_key_press
    print ">>"
    key_press = gets.chomp.to_i

    until key_press.between?(0,9)
      print ">>"
      key_press = gets.chomp.to_i
    end

    key_press
  end
end

class KeypadTester
  def initialize length, mode_keys
    @keypad = Keypad.new(mode_keys, length)
    @key_presses = 0
    @length = length
    @mode_keys = mode_keys
  end

  def run
    number_bank = []
    @length.times { number_bank += (0..9).to_a }
    sequences = number_bank.permutation(@length).to_a.uniq

    sequences.each_with_index do |sequence, idx|
      sequence.each do |num|
        @keypad.press(num)
        @key_presses += 1
      end
      unless sequence != sequences.last && @mode_keys.include?(sequences[idx + 1][0])
        @keypad.press(@mode_keys[0])
        @key_presses += 1
      end
    end
    p @key_presses
    p @keypad.all_codes_entered?
  end

end

k = KeypadTester.new(4, [1,2,3])
k.run

# k = Keypad.new([1,2,3],1)
# until k.all_codes_entered?
#   k.press
#   p k.key_history
#   p k.code_bank
#   p k.all_codes_entered?
# end
