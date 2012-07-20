class EnigmaController < ApplicationController
  caches_page :index

  def index
  end

  def ciphered
    rotor_numbers = params[:post][:rotor_numbers].split("").map{|num|num.to_i}
    rotor_offsets = params[:post][:rotor_offsets].split("")
    reflector_number = params[:post][:reflector_number].to_i
    plugboard = params[:post][:plugboard]
    input_text = params[:post][:input_text]
    enigma = EnigmaMachine.new(rotor_numbers, rotor_offsets, reflector_number, plugboard)
    @output = enigma.cipher(input_text)

    expire_page :action => :index
    render :action => 'index'
  end
end
