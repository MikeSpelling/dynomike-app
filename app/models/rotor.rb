class Rotor < ActiveRecord::Base

  attr_reader :offset, :notches

  def initialize(ciphabet, notches = "", offset = "A")
    @alphabet = ("A".."Z").to_a
    @ciphabet = ciphabet.split ""
    @offset = @alphabet.index(offset)

    notches.split(",").each do |notch|
      @notches.nil? ? @notches=[@alphabet.index(notch)] : @notches<<@alphabet.index(notch)
    end
  end

  def cipher(character)
    @alphabet[get_output_num(@ciphabet, @alphabet, character)]
  end

  def decipher(character)
    @alphabet[get_output_num(@alphabet, @ciphabet, character)]
  end

  def rotate(times = 1)
    @offset += times
  end

  def set_offset(character)
    @offset = @alphabet.index(character)
  end

  private
  def get_output_num(input_alphabet, output_alphabet, character)
    input_num = (@alphabet.index(character) + @offset) % 26
    (output_alphabet.index(input_alphabet[input_num]) - @offset) % 26
  end
  
end

