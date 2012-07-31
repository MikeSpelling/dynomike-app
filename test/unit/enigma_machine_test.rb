require 'test_helper'

class EnigmaMachineTest < ActiveSupport::TestCase

  test "It should cipher a character" do
    rotors = [1, 2, 3]
    offsets = ["M", "C", "K"]
    reflector = 1
    enigma = EnigmaMachine.new(rotors, offsets, reflector)

    input_string = "E"
    expected_output = "Q"
    assert_equal expected_output, enigma.cipher(input_string)
  end

  test "It should decipher a character" do
    rotors = [1, 2, 3]
    offsets = ["M", "C", "K"]
    reflector = 1
    enigma = EnigmaMachine.new(rotors, offsets, reflector)

    input_string = "Q"
    expected_output = "E"
    assert_equal expected_output, enigma.cipher(input_string)
  end

  test "It should decipher a string" do
    rotors = [1, 2, 3]
    offsets = ["M", "C", "K"]
    reflector = 1
    enigma = EnigmaMachine.new(rotors, offsets, reflector)

    input_string = "QMJIDOMZWZJFJR"
    expected_output = "ENIGMAREVEALED"
    assert_equal expected_output, enigma.cipher(input_string)
  end

  test "It should be symmetric" do
    rotors = [1, 2, 3]
    offsets = ["M", "C", "K"]
    reflector = 1
    enigma = EnigmaMachine.new(rotors, offsets, reflector)

    input_string = "abcdefeghijklmnopqrstuvwxyz"
    output = enigma.cipher(input_string)
    enigma.reset
    assert_equal input_string.upcase, enigma.cipher(output)
  end

  test "It is still symmetric with different settings and plugboard" do
    rotors = [2, 3, 1]
    offsets = ["X", "D", "L"]
    reflector = 1
    plugboard = "AX,FY,GE,JL,QW,ZS,BC"
    enigma = EnigmaMachine.new(rotors, offsets, reflector, plugboard)

    input_string = "abcdefeghijklmnopqrstuvwxyz"
    output = enigma.cipher(input_string)
    enigma.reset
    assert_equal input_string.upcase, enigma.cipher(output)
  end

  test "The new rotors keep symmetry" do
    rotors = [4, 5, 8, 7, 6, 2, 1, 3]
    offsets = ["F", "F", "Q", "A", "X", "I", "O", "C"]
    reflector = 1
    enigma = EnigmaMachine.new(rotors, offsets, reflector)

    input_string = "abcdefeghijklmnopqrstuvwxyz"
    output = enigma.cipher(input_string)
    enigma.reset
    assert_equal input_string.upcase, enigma.cipher(output)
  end

  test "The new reflectors keeps symmetry" do
    rotors = [1, 2, 3]
    offsets = ["A", "B", "C"]
    reflector = 2
    enigma = EnigmaMachine.new(rotors, offsets, reflector)

    input_string = "abcdefeghijklmnopqrstuvwxyz"
    output = enigma.cipher(input_string)
    enigma.reset
    assert_equal input_string.upcase, enigma.cipher(output)
  end

end
