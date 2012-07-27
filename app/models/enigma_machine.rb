class EnigmaMachine < ActiveRecord::Base

  def initialize(rotor_numbers = [1], offsets = "A", reflector_number = 1, plugboard = "")
    rotor1 = Rotor.new("EKMFLGDQVZNTOWYHXUSPAIBRCJ", "Q")
    rotor2 = Rotor.new("AJDKSIRUXBLHWTMCQGZNPYFVOE", "E")
    rotor3 = Rotor.new("BDFHJLCPRTXVZNYEIWGAKMUSQO", "V")
    rotor4 = Rotor.new("ESOVPZJAYQUIRHXLNFTGKDCMWB", "J")
    rotor5 = Rotor.new("VZBRGITYUPSDNHLXAWMJQOFECK", "Z")
    rotor6 = Rotor.new("JPGVOUMFYQBENHZRDKASXLICTW", "Z,M")
    rotor7 = Rotor.new("NZJHGRCXMYSWBOUFAIVLPEKQDT", "Z,M")
    rotor8 = Rotor.new("FKQHTLXOCBJSPDZRAMEWNIUYGV", "Z,M")
    @all_rotors = [rotor1, rotor2, rotor3, rotor4, rotor5, rotor6, rotor7, rotor8]

    reflector1 = Rotor.new("YRUHQSLDPXNGOKMIEBFZCWVJAT")
    reflector2 = Rotor.new("EJMZALYXVBWFCRQUONTSPIKHGD")
    reflector3 = Rotor.new("FVPJIAOYEDRZXWGCTKUQSBNMHL")
    reflector4 = Rotor.new("ENKQAUYWJICOPBLMDXZVFTHRGS")
    reflector5 = Rotor.new("RDOBJNTKVEHMLFCWZAXGYIPSUQ")
    @all_reflectors = [reflector1, reflector2, reflector3, reflector4, reflector5]

    @reflector = @all_reflectors[reflector_number-1]
    set_rotors(rotor_numbers, offsets)
    set_plugboard(plugboard)
  end

  def cipher(text)
    text.upcase.split("").map do |character|
      ("A".."Z").include?(character) ? encode(character) : character
    end.join("")
  end

  def set_rotors(rotor_numbers, offsets)
    @offsets = offsets

    rotor_numbers.each_with_index do |rotor_number, index|
      rotor = @all_rotors[rotor_number-1]
      rotor.set_offset offsets[index]
      @rotors.nil? ? @rotors=[rotor] : @rotors<<rotor
    end
  end

  def set_reflector(reflector_number)
    @reflector = @all_reflectors[reflector_number-1]
  end

  def set_plugboard(settings) # Settings in format AB,CD to swap A with B and C with D
    @plugboard = {"A"=>"A", "B"=>"B", "C"=>"C", "D"=>"D", "E"=>"E", "F"=>"F", "G"=>"G", "H"=>"H", "I"=>"I", "J"=>"J", "K"=>"K", "L"=>"L", "M"=>"M",
    "N"=>"N", "O"=>"O", "P"=>"P", "Q"=>"Q", "R"=>"R", "S"=>"S", "T"=>"T", "U"=>"U", "V"=>"V", "W"=>"W", "X"=>"X", "Y"=>"Y", "Z"=>"Z"}

    settings.split(",").each do |pair|
      chars = pair.split("")
      @plugboard[chars[0].upcase] = chars[1].upcase
      @plugboard[chars[1].upcase] = chars[0].upcase
    end
  end

  def reset
    @rotors.each_with_index do |rotor, index|
      rotor.set_offset @offsets[index]
    end
  end

  private
  def encode(character)
    rotate
    character = @plugboard[character]
    @rotors.reverse.each do |rotor|
      character = rotor.cipher(character)
    end
    character = @reflector.cipher(character)
    @rotors.each do |rotor|
      character = rotor.decipher(character)
    end
    @plugboard[character]
  end

  def rotate
    @rotors.size.times do |count|
      if count == 0 and @rotors[0].notches.include? @rotors[0].offset # First rotor rotates all others if at notch
        @rotors.each{|rotor| rotor.rotate}
      else
        @rotors[count-1].rotate if @rotors[count].notches.include? @rotors[count].offset
        @rotors[count].rotate if count == @rotors.size-1 # Last rotor always rotates
      end
    end
  end
  
end

