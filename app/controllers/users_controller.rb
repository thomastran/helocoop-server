class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create_data_test
    phone_number = ['+841269162753', '+841204617647', '+84972341808', '+84986503988']
    email = 'Samaritan@gmail.com'
    4.times do |i|
      phone_number_temp = phone_number.at(i)
      token_temp = generate_token
      latitude_temp = random_location
      longitude_temp = random_location
      user_temp = {
        :phone_number => phone_number_temp,
        :email => email,
        :token => token_temp,
        :latitude => latitude_temp,
        :longitude => longitude_temp,
        :instance_id => token_temp,
        :available => true
      }
      user = User.new(user_temp)
      user.save
    end
    render json: {:ok => 'ok'}
  end

  def find_nearest_people(initial_address)
    address_temp = Address.new 47.858205, 2.294359, nil, nil, nil, nil, nil, nil
    addresses = []
    distances = []
    users = User.where("available = ?", true)
    users.each { |user| addresses.push(Address.new user.latitude, user.longitude, user.token, user.instance_id, user.phone_number, user.name, user.description, user.address)}
    addresses.each { |address| distances.push(Distance.new(caculate_location(initial_address, address), address.getToken, address.getInstanceId, address.getPhoneNumber, address.getName, address.getDescription, address.getAddress))}
    distances.sort! { |a,b| a.getMile <=> b.getMile }
    return distances.take(3)
  end

  def test_location
    address_temp = Address.new 47.858205, 2.294359, nil, nil, nil
    addresses = []
    distances = []
    users = User.where("available = ?", true)
    users.each { |user| addresses.push(Address.new user.latitude, user.longitude, user.token, user.instance_id, user.phone_number)}
    addresses.each { |address| distances.push(Distance.new(caculate_location(address_temp, address), address.getToken, address.getInstanceId, address.getPhoneNumber))}
    distances.sort! { |a,b| a.getMile <=> b.getMile }
    render json: distances.take(2)
  end

  def find_people_to_call
    if params.include?(:token)
      if User.exists?(:token => params[:token])
        user = User.find_by(token: params[:token])
        initial_address = Address.new user.latitude, user.longitude, user.token, user.instance_id
        distances = find_nearest_people initial_address
        request_to_gcm distances
        success = true
        message = 'successfully'
      else
        success = false
        message = 'token does not exist'
      end
    else
      success = false
      message = 'please check your paramaters'
    end
    result = {:success => success, :message => message}
    render json: result
  end


  def make_conference_call
    if params.include?(:token)
      if User.exists?(:token => params[:token])
        user = User.find_by(token: params[:token])
        initial_address = Address.new user.latitude, user.longitude, user.token, user.instance_id, user.phone_number, user.name, user.description, user.address
        distances = find_nearest_people initial_address
        call_client_to_join_conference distances
        success = true
        message = 'successfully'
      else
        success = false
        message = 'token does not exist '
        distances = nil
      end
    else
      success = false
      message = 'please check your paramaters again'
      distances = nil
    end
    result = {:success => success, :message => message, :distances => distances}
    render json: result
  end

  def call_client_to_join_conference(distances)
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token  = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new account_sid, auth_token
    url = 'https://sleepy-tundra-5643.herokuapp.com/users/callconference'
    phone_number = '+14157809231'
    distances.each { |distance| @client.account.calls.create(
    :url => url,
    :to => distance.getPhoneNumber,
    :from => phone_number
    )}
    # distances.each do |key, array|
    #   @client.account.calls.create(
    #   :url => url,
    #   :to => array,
    #   :from => phone_number
    #   )
    # end
  end


  def request_code
    activate_code = random_activate_code
    if params.include?(:phone_number)
      activate_code = activate_code.to_s
      send_sms params[:phone_number], activate_code
      if User.exists?(:phone_number => params[:phone_number])
        user = User.find_by(phone_number: params[:phone_number])
        user_temp = { :code => activate_code }
        user.update(user_temp)
        result = { :success => true, :message => "updated new phone number successfully" }
      else
        user_temp = { :phone_number => params[:phone_number], :code => activate_code }
        @user = User.new(user_temp)
        if @user.save
          result = { :success => true, :message => "created new phone number successfully" }
        else
          result = { :success => false, :message => "created new phone number unsuccessfully" }
        end
      end
    end
    render json: result, status: 200
  end

  def update
    if params.include?(:phone_number) and params.include?(:name) and params.include?(:address) and params.include?(:email) and params.include?(:description)
      phone_number = params[:phone_number]
      name = params[:name]
      address = params[:address]
      email = params[:email]
      description = params[:description]
      render json: update_user(phone_number, email, address, name, description)
    else
      result = { :success => false, :message => "please check the paramaters" }
      render json: result
    end
  end

  def verify_code
    if params.include?(:phone_number) and params.include?(:activate_code) and params.include?(:instance_id)
      if User.exists?(:phone_number => params[:phone_number], :code => params[:activate_code])
        user_temp = {:instance_id => params[:instance_id]}
        user = User.find_by(:phone_number => params[:phone_number], :code => params[:activate_code])
        if user.update(user_temp)
          success = true
          message = "activate successfully"
        else
          success = false
          message = "cannot update instance id successfully"
        end
      else
        success = false
        message = "phone number doesn't exist or code activate is not ok"
      end
    else
      success = false
      message = "please check the paramaters"
    end
    result = { :success => success, :message => message }
    render json: result, status: 200
  end

  def update_location
    if params.include?(:latitude) and params.include?(:longitude) and params.include?(:token)
      user_temp = {:latitude => params[:latitude], :longitude => params[:longitude], :available => true }
      user = User.find_by(:token => params[:token])
      if user.update(user_temp)
        success = true
        message = "Update location successfully !"
      else
        success = false
        message = "Cannot update data into table users"
      end
    else
      success = false
      message = "Please check paramaters"
    end
    result = {:success => success, :message => message}
    render json: result
  end

  def turn_off_samaritan
    if params.include?(:token)
      user_temp = {:available => false}
      if User.exists?(:token => params[:token])
        user = User.find_by(:token => params[:token])
        if user.update user_temp
          success = true
          message = 'Turn off Samaritan successfully'
        else
          success = false
          message = 'Cannot turn off Samaritan'
        end
      else
        success = false
        message = 'Token does not exist'
      end
    else
      success = false
      message = 'Please check your paramaters '
    end
    result = {:success => success, :message => message}
    render json: result
  end

  def callclient
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token  = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new account_sid, auth_token
    numbers = ["+841269162753", "+84972341808", "+84902585979"]
    numbers.each do |number|
      @client.account.calls.create(:url => "https://sleepy-tundra-5643.herokuapp.com/users/callconference",
      :to => number,
      :from => "+14157809231"
      )
    end
    render json: {:go => true}
  end

  def twilio
    render xml: call_conference.to_xml
  end

  def event
      puts params.to_s
      render json: params
  end

  def call_conference
    Twilio::TwiML::Response.new do |response|
      response.Say "You have joined the conference."

      response.Dial callerId: params[:Caller] do |dial|
        dial.Conference "conference",
          waitUrl: "http://twimlets.com/holdmusic?Bucket=com.twilio.music.classical",
          muted:  "false",
          startConferenceOnEnter: "true",
          endConferenceOnExit: "true"
      end
    end
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
    result = { :success => success }
    render json: result, status: 200
  end

  def making_request_to_gcm
    token_registation = 'dyrIug-Vg3k:APA91bHiKm-LJnSugFoVgH8hpWoi4lRSD8F_sJ4M_QZKWjekL0dLTWEolvNSZ9h8wQ_qduivMpuGK9o79eJuP_g9V3cONs7N9KSSRO-kXOguBFoa0_UYuqSM9ziYGajYs6D3M3qcINL7'
    authorization = 'key=AIzaSyBmj7ad8xxn2wPf7zD4bb02-wI4mI8keWg'
    data = {:data => {:message => 'Novahub Studio Like You', :time => '123'}, :to => '/topics/global'}.to_json
    header = {:Authorization => authorization, :content_type => 'application/json'}
    response = RestClient.post 'https://gcm-http.googleapis.com/gcm/send', data, header
    render json: response
  end
  private

  def request_to_gcm(distances)
    distances.each {|distance| request_to_device distance.getInstanceId}
  end

  def request_to_device(instance_id)
    authorization = 'key=AIzaSyBmj7ad8xxn2wPf7zD4bb02-wI4mI8keWg'
    data = {:data => {:message => 'Novahub Studio Like You', :time => '123'}, :to => instance_id}.to_json
    header = {:Authorization => authorization, :content_type => 'application/json'}
    response = RestClient.post 'https://gcm-http.googleapis.com/gcm/send', data, header
  end

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

  def update_user(phone_number, email, address, name, description)
    token = generate_token
    user_temp = { :email => email, :address => address, :name => name, :token => token, :description => description }
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
    prng.rand(100000..999999)
  end

  def random_location
    prng = Random.new
    prng.rand(0..9999)
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
