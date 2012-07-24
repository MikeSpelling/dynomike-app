class EnigmaController < ApplicationController
  caches_page :index

  def index
    @cipher_count = CipherCount.all[0][:total]
  end

  def ciphered
    rotor_numbers = params[:post][:rotor_numbers].split("").map{|num|num.to_i}
    rotor_offsets = params[:post][:rotor_offsets].split("")
    reflector_number = params[:post][:reflector_number].to_i
    plugboard = params[:post][:plugboard]
    input_text = params[:post][:input_text]
    enigma = EnigmaMachine.new(rotor_numbers, rotor_offsets, reflector_number, plugboard)
    @output = enigma.cipher(input_text)

    @cipher_counter = CipherCount.all[0]
    @cipher_count = @cipher_counter[:total]+1
    @cipher_counter.update_attributes(:total => @cipher_count)

    expire_page :action => :index
    render :action => 'index'
  end
end
