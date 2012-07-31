require 'test_helper'

class RotorTest < ActiveSupport::TestCase

  setup do
    rotor3 = Rotor.new("BDFHJLCPRTXVZNYEIWGAKMUSQO", "V", "K")
    rotor2 = Rotor.new("AJDKSIRUXBLHWTMCQGZNPYFVOE", "E", "C")
    rotor1 = Rotor.new("EKMFLGDQVZNTOWYHXUSPAIBRCJ", "Q", "M")
    @rotors = [rotor1, rotor2, rotor3]
  end

  test "It should return the notch" do
    assert_equal [21], @rotors[2].notches
  end

  test "It should map forwards" do
    assert_equal "N", @rotors[2].cipher("A")
  end

  test "It should map backwards" do
    assert_equal "S", @rotors[0].decipher("Z")
  end

  test "Reflector should map a number" do
    reflector = Rotor.new("YRUHQSLDPXNGOKMIEBFZCWVJAT")
    assert_equal "Y", reflector.cipher("A")
  end

end