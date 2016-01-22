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

  # get phone number from android device and send sms to that phone number
  def request_code
    activate_code = random_activate_code.to_s
    if params.include?(:phone_number)
      send_sms params[:phone_number], activate_code
      if User.exists?(:phone_number => params[:phone_number])
        user = User.find_by(phone_number: params[:phone_number])
        user_temp = {:code => activate_code}
        user.update(user_temp)
        result = {:success => true, :message => 'updated new phone number successfully'}
      else
        user_temp = {:phone_number => params[:phone_number], :code => activate_code}
        @user = User.new(user_temp)
        if @user.save
          result = {:success => true, :message => 'created new phone number successfully'}
        else
          result = {:success => false, :message => 'created new phone number unsuccessfully'}
        end
      end
    end
    render json: result, status: 200
  end

  # verify code to activate the phone number
  def verify_code
    if params.include?(:phone_number) and params.include?(:activate_code) and params.include?(:instance_id)
      if User.exists?(:phone_number => params[:phone_number], :code => params[:activate_code])
        user_temp = {:instance_id => params[:instance_id]}
        user = User.find_by(:phone_number => params[:phone_number], :code => params[:activate_code])
        if user.update(user_temp)
          success = true
          message = 'activate successfully'
        else
          success = false
          message = 'cannot update instance id successfully'
        end
      else
        success = false
        message = 'phone number does not exist or code activate is not ok'
      end
    else
      success = false
      message = 'please check the paramaters'
    end
    result = { :success => success, :message => message }
    render json: result, status: 200
  end

  # update information name, email, address, description
  def update
    if params.include?(:phone_number) and params.include?(:name) and params.include?(:address) and params.include?(:email) and params.include?(:description)
      phone_number = params[:phone_number]
      name = params[:name]
      address = params[:address]
      email = params[:email]
      description = params[:description]
      render json: update_user(phone_number, email, address, name, description)
    else
      result = {:success => false, :message => 'please check the paramaters'}
      render json: result
    end
  end

  # turn off Samaritan
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

  # Update location and turn on Samaritan status to true
  def update_location
    if params.include?(:latitude) and params.include?(:longitude) and params.include?(:token)
      user_temp = {:latitude => params[:latitude], :longitude => params[:longitude], :available => true }
      user = User.find_by(:token => params[:token])
      if user.update(user_temp)
        success = true
        message = 'Update location successfully !'
      else
        success = false
        message = 'Cannot update data into table users'
      end
    else
      success = false
      message = 'Please check paramaters'
    end
    result = {:success => success, :message => message}
    render json: result
  end

  # initializing a new room, calling to other phone number to join the room
  def make_conference_call
    if params.include?(:token) and params.include?(:name_room)
      if User.exists?(:token => params[:token])
        user = User.find_by(token: params[:token])
        distances = find_nearest_people user
        if distances.length >= 2
          call_client_to_join_conference distances, params[:name_room]
        end
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

  def twilio
    render xml: call_conference(params[:name_room], params[:participants]).to_xml
  end

  def learn_ruby
    distance = Distance.new 10, 'sam', 'sam', 'sam', 'ppppp'
    puts distance.mile
    puts distance.name
    render json: {:ok => 'fuck'}
  end
  private

  def send_sms(phone_number, activate_code)
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token  = ENV['TWILIO_AUTH_TOKEN']
    message = 'Your HelpCoop activation number is '+ activate_code +'. Please enter this number in the HelpCoop app to activate.'
    @client = Twilio::REST::Client.new account_sid, auth_token
    @client.account.messages.create({
      :from => '+14157809231',
      :to => phone_number,
      :body => message
    })
  end

  def update_user(phone_number, email, address, name, description)
    token = generate_token
    user_temp = { :email => email, :address => address, :name => name, :token => token, :description => description }
    user = User.find_by(phone_number: phone_number)
    if user.update(user_temp)
      success = true
      message = 'updated successfully'
      token_response = token
    else
      success = false
      message = 'updated unsuccessfully'
      token_response = nil
    end
    result = Info_Response.new(success, message, token_response)
    return result
  end

  def find_nearest_people(user_initial)
    distances = []
    users = User.where("available = ?", true)
    users.each do |user|
      distance = caculate_location(user_initial, user)
      distances.push(Distance.new(distance, user.phone_number, user.name, user.description, user.address))
      # if distance < 10
      #   distances.push(Distance.new(distance, user.phone_number, user.name, user.description, user.address))
      # end
    end
    distances.sort! { |a,b| a.getMile <=> b.getMile }
    return distances.take(3)
  end

  def call_client_to_join_conference(distances, name_room)
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token  = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new account_sid, auth_token
    url = 'https://sleepy-tundra-5643.herokuapp.com/users/callconference?name_room=#{ name_room }&participants=#{ distances.length }'
    phone_number = '+14157809231'
    distances.each { |distance| @client.account.calls.create(
      :url => url,
      :to => distance.getPhoneNumber,
      :from => phone_number
    )}
  end

  def call_conference(name_room, participants)
    if participants == 2
      message = 'We have found 1 person ready to help you '
    elsif participants == 3
      message = 'We have found 2 people ready to help you '
    else
      message = 'You have joined the conference.'
    end
    Twilio::TwiML::Response.new do |response|
      response.Say message
      response.Dial callerId: params[:Caller] do |dial|
        dial.Conference name_room,
          waitUrl: "http://twimlets.com/holdmusic?Bucket=com.twilio.music.classical",
          muted:  "false",
          startConferenceOnEnter: "true",
          endConferenceOnExit: "true"
      end
    end
  end

  def random_activate_code
    prng = Random.new
    prng.rand(100000..999999)
  end

  def generate_token
      token = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless User.exists?(:token => random_token)
      end
      return token
  end

  def caculate_location(user_first, user_second)
    Geocoder::Calculations.distance_between([user_first.latitude, user_first.longitude], [user_second.latitude, user_second.longitude])
  end

  def making_request_to_gcm
    token_registation = 'dyrIug-Vg3k:APA91bHiKm-LJnSugFoVgH8hpWoi4lRSD8F_sJ4M_QZKWjekL0dLTWEolvNSZ9h8wQ_qduivMpuGK9o79eJuP_g9V3cONs7N9KSSRO-kXOguBFoa0_UYuqSM9ziYGajYs6D3M3qcINL7'
    authorization = 'key=AIzaSyBmj7ad8xxn2wPf7zD4bb02-wI4mI8keWg'
    data = {:data => {:message => 'Novahub Studio Like You', :time => '123'}, :to => '/topics/global'}.to_json
    header = {:Authorization => authorization, :content_type => 'application/json'}
    response = RestClient.post 'https://gcm-http.googleapis.com/gcm/send', data, header
    render json: response
  end

  def request_to_gcm(distances)
    distances.each {|distance| request_to_device distance.getInstanceId}
  end

  def random_location
    prng = Random.new
    prng.rand(10..10)
  end

  def request_to_device(instance_id)
    authorization = 'key=AIzaSyBmj7ad8xxn2wPf7zD4bb02-wI4mI8keWg'
    data = {:data => {:message => 'Novahub Studio Like You', :time => '123'}, :to => instance_id}.to_json
    header = {:Authorization => authorization, :content_type => 'application/json'}
    response = RestClient.post 'https://gcm-http.googleapis.com/gcm/send', data, header
  end

  def do_register
    if params.include?(:phone_number)
      phoneNumber = params[:phone_number]
      Rails.logger.info phoneNumber
    end
  end
end
