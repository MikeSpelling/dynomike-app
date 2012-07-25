class EnigmaController < ApplicationController

  def index
    @rotor_numbers = params[:rotor_numbers].nil? ? nil : params[:rotor_numbers]
    @rotor_offsets = params[:rotor_offsets].nil? ? nil : params[:rotor_offsets]
    @reflector_number = params[:reflector_number].nil? ? nil : params[:reflector_number]
    @plugboard = params[:plugboard].nil? ? nil : params[:plugboard]

    @settings = "#{@rotor_numbers}:#{@rotor_offsets}:#{@reflector_number}:#{@plugboard}" unless @rotor_numbers.nil? and @rotor_offsets.nil? and @plugboard.nil?

    @cipher_count = CipherCount.all[0][:total]
  end

  def ciphered
    rotor_numbers = params[:post][:rotor_numbers].split("").map { |num| num.to_i }
    rotor_offsets = params[:post][:rotor_offsets].split("")
    reflector_number = params[:post][:reflector_number].to_i
    plugboard = params[:post][:plugboard]
    input_text = params[:post][:input_text]
    enigma = EnigmaMachine.new(rotor_numbers, rotor_offsets, reflector_number, plugboard)
    @output = enigma.cipher(input_text)
    @settings = "#{params[:post][:rotor_numbers]}:#{params[:post][:rotor_offsets]}:#{params[:post][:reflector_number]}:#{params[:post][:plugboard]}"

    @cipher_counter = CipherCount.all[0]
    @cipher_count = @cipher_counter[:total]+1
    @cipher_counter.update_attributes(:total => @cipher_count)

    render :action => 'index'
  end

  def random
    num_rotors = rand(0..7)
    rotor_numbers = ""
    Array(1..8).shuffle[0..num_rotors].map{|item| rotor_numbers << item.to_s}
    rotor_offsets = ""
    ("A".."Z").to_a.shuffle[0..num_rotors].map{|item| rotor_offsets << item}
    reflector_number = rand(1..5)
    random_alphabet = ("A".."Z").to_a.shuffle
    plugboard = ""
    offset = 0
    rand(0..10).times do |index|
      plugboard = "#{random_alphabet[index+offset]}-#{random_alphabet[index+offset+1]},#{plugboard}"
      offset += 1
    end
    plugboard = plugboard[0..-2] #Remove trailing comma

    redirect_to :action => 'index', :rotor_numbers => rotor_numbers, :rotor_offsets => rotor_offsets, :reflector_number => reflector_number, :plugboard => plugboard
  end

  def load_settings
    settings = params[:post][:settings].split(":")
    rotor_numbers = settings[0]
    rotor_offsets = settings[1]
    reflector_number = settings[2]
    plugboard = settings[3]

    redirect_to :action => 'index', :rotor_numbers => rotor_numbers, :rotor_offsets => rotor_offsets, :reflector_number => reflector_number, :plugboard => plugboard
  end
end
