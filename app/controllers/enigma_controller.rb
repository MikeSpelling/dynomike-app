class EnigmaController < ApplicationController
  def index
  end

  def ciphered
    input = params[:post][:input_text]
    enigma = EnigmaMachine.new([1,2,3], ["M", "C", "K"], 1, "")
    @output = enigma.cipher(input)
  end
end
