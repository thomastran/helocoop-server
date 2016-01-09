class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def request_code
    activate_code = random_activate_code
    if params.include?(:phone_number)
      activate_code = params[:phone_number] + activate_code.to_s
      send_sms params[:phone_number], activate_code
      if User.exists?(:phone_number => params[:phone_number])
        user = User.find_by(phone_number: params[:phone_number])
        user_temp = { "code" => activate_code }
        user.update(user_temp)
        result = { "success" => true, "message" => "updated new phone number successfully" }
      else
        user_temp = { "phone_number" => params[:phone_number], "code" => activate_code }
        @user = User.new(user_temp)
        if @user.save
          result = { "success" => true, "message" => "created new phone number successfully" }
        else
          result = { "success" => false, "message" => "created new phone number unsuccessfully" }
        end
      end
    end
    render json: result, status: 200
  end

  def update
    if params.include?(:phone_number) and params.include?(:name) and params.include?(:address) and params.include?(:email)
      phone_number = params[:phone_number]
      name = params[:name]
      address = params[:address]
      email = params[:email]
      render json: update_user(phone_number, email, address, name)
    else
      result = { "success" => false, "message" => "please check the paramaters" }
      render json: result
    end
  end

  def verify_code
    if params.include?(:phone_number) and params.include?(:activate_code)
      user = User.find_by(phone_number: params[:phone_number], code: params[:activate_code])
      if user != nil
        Rails.logger.info user.phone_number
        Rails.logger.info user.code
        success = true
        message = "activate successfully"
      else
        success = false
        message = "phone number doesn't exist or code activate is not ok"
      end
    else
      success = false
      message = "please check the paramaters"
    end
    result = { "success" => success, "message" => message }
    render json: result, status: 200
  end

  def show_all_user
    address_first = Address.new 47.858205, 2.294359, nil
    address_second = Address.new 40.748433, -73.985655, nil
    address_third = Address.new 10.748433, -53.985655, nil
    address_fourth = Address.new 60.748433, -23.985655, nil
    arr_of_address = []
    arr_of_address.push(address_first)
    arr_of_address.push(address_second)
    arr_of_address.push(address_third)
    arr_of_address.push(address_fourth)
    puts sort_by_distance(arr_of_address, address_first).to_s
    puts arr_of_address.to_s
    puts caculate_location address_first, address_second
    render json: User.all, status: 200
  end

  def clear_data_user
    if User.delete_all
      success = true
    else
      success = false
    end
    result = { "success" => success }
    render json: result, status: 200
  end

  def making_request_to_gcm
    token_registation = 'fDWWKhst2vQ:APA91bGYUldqj2zEcDF7zd7Wkk5bPPERTEi9wjU5z-P_maj1ATNKzDuplXOHO4q4HmvhljZRb5YTuMTWWbtWkG9sr2gLso74tQHY9t0KxNkZE1eVkUXzg4BTP01adh3U8B0FBCvu2cDw'
    authorization = 'key=AIzaSyC6aXtvQBxqEueZ3MYN9EmSp3Kqv1JY-EM'
    data = {:data => {:message => 'Novahub Studio Like You', :time => '123'}, :to => token_registation}.to_json
    header = {:Authorization => authorization, :content_type => 'application/json'}
    response = RestClient.post 'https://gcm-http.googleapis.com/gcm/send', data, header
    render json: response
  end
  private

  def send_sms(phone_number, activate_code)

    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token  = ENV['TWILIO_AUTH_TOKEN']

    @client = Twilio::REST::Client.new account_sid, auth_token

    @client.account.messages.create({
      :from => '+14157809231',
      :to => phone_number,
      :body => activate_code
    })

  end

  def do_register
    if params.include?(:phone_number)
      phoneNumber = params[:phone_number]
      Rails.logger.info phoneNumber
    end
  end

  def update_user(phone_number, email, address, name)
    token = generate_token
    user_temp = { "email" => email, "address" => address, "name" => name, "token" => token }
    user = User.find_by(phone_number: phone_number)
    if user.update(user_temp)
      success = true
      message = "updated successfully"
      token_response = token
    else
      success = false
      message = "updated unsuccessfully"
      token_response = nil
    end
    result = Info_Response.new(success, message, token_response)
    return result
  end


  def random_activate_code
    prng = Random.new
    prng.rand(1000..9999)
  end

  def generate_token
      # random_token = SecureRandom.urlsafe_base64(nil, false)
      token = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless User.exists?(:token => random_token)
      end
      return token
  end

  def caculate_location(address_first, address_second)
      Geocoder::Calculations.distance_between([address_first.getLatitude, address_first.getLongitude], [address_second.getLatitude, address_second.getLongitude])
  end

  def sort_by_distance(arr_of_address, initial_address)
    arr_of_distance = []
    arr_of_address.each { |address| arr_of_distance.push(Distance.new(caculate_location(address, initial_address), address.getToken)) }
    arr_of_distance.sort! { |a,b| a.getMile <=> b.getMile }
    return arr_of_distance
  end

end
