require 'test_helper'

class EnigmaControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert assigns(:cipher_count).to_i >= 0
  end

  test "100 randomised enigma settings" do
    100.times do
      get :random

      plugboard = assigns(:plugboard)
      reflector = assigns(:reflector_number)
      rotors = assigns(:rotor_numbers)
      offsets = assigns(:rotor_offsets)

      unless plugboard.nil?
        plugboard.split(",").each do |pair|
          assert_match /[A-Z]{2}/, pair
        end
      end
      assert_match /[1-5]/, reflector
      assert_match /[1-8]{1,8}/, rotors
      assert_match /[A-Z]{#{rotors.size}}/, offsets

      assert_match /http:\/\/[\w.]*\/enigma\?plugboard=#{plugboard.gsub(",", "%2C")}&reflector_number=#{reflector}&rotor_numbers=#{rotors}&rotor_offsets=#{offsets}/, @response.redirect_url
    end
  end

  test "load setting" do
    post :load_settings, :post => {:settings => "123-ABC-1-AB,CD"}

    settings = assigns(:settings)
    rotors = settings[0]
    offsets = settings[1]
    reflector = settings[2]
    plugboard = settings[3]

    assert_equal "123", rotors
    assert_equal "ABC", offsets
    assert_equal "1", reflector
    assert_equal "AB,CD", plugboard

    assert_match /http:\/\/[\w.]*\/enigma\?plugboard=#{plugboard.gsub(",", "%2C")}&reflector_number=#{reflector}&rotor_numbers=#{rotors}&rotor_offsets=#{offsets}/, @response.redirect_url
  end

  test "cipher" do
    original_cipher_count = CipherCount.all[0][:total]
    post :ciphered, :post => {:rotor_numbers => "123", :rotor_offsets => "ABC", :reflector_number => "1", :plugboard => "AB,CD", :input_text => "test"}

    enigma = EnigmaMachine.new([1,2,3], ["A", "B", "C"], 1, "AB,CD")
    assert_equal enigma.cipher("test"), assigns(:output), "Output ciphered correctly"
    assert_equal "123-ABC-1-AB,CD", assigns(:settings), "Settings stored correctly"
    assert_equal original_cipher_count+1, assigns(:cipher_count), "Cipher count incremented correctly"
    assert_equal original_cipher_count+1, CipherCount.all[0][:total], "New cipher count stored"
  end

end 
