module ApplicationHelper
  def ApplicationHelper.test()
    puts "just testing" + ApplicationHelper.generate_token
  end

  def ApplicationHelper.send_sms(phone_number, activate_code)
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

  def ApplicationHelper.update_user(phone_number, email, address, name, description)
    token = ApplicationHelper.generate_token
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

  def ApplicationHelper.update_user_voip(phone_number, email, address, name, description)
    token = ApplicationHelper.generate_token
    user_temp = { :email => email, :address => address, :name => name, :token => token, :description => description }
    user = UsersVoip.find_by(phone_number: phone_number)
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

  def ApplicationHelper.call_client_to_join_conference(distances, name_room, initilial_user)
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token  = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new account_sid, auth_token
    phone_number = '+14157809231'
    is_from_caller = true
    name_of_caller = initilial_user.name.delete(' ')

    # Create log for callconference
    log_temp = {:name_room => name_room, :participants => distances.length + 1, :caller => initilial_user.name, :user_id => initilial_user.id}
    log = Log.new log_temp
    log.save
    # done

    url = "http://162.242.175.133/users/callconference?name_room=#{ name_room }&participants=#{ distances.length }&is_from_caller=#{ is_from_caller }&name_of_caller=#{ name_of_caller }"
    # Call to initilial_user first
    @client.account.calls.create(
      :url => url,
      :to => initilial_user.phone_number,
      :from => phone_number
    )
    # Call to the remaining users
    is_from_caller = false
    url = "http://162.242.175.133/users/callconference?name_room=#{ name_room }&participants=#{ distances.length }&is_from_caller=#{ is_from_caller }&name_of_caller=#{ name_of_caller }"
    distances.each do |distance|
      @client.account.calls.create(
        :url => url,
        :to => distance.phone_number,
        :from => phone_number
      )
    end
  end

  def ApplicationHelper.send_data_to_devices(distances, initilial_user, name_room)
    authorization = 'key=AIzaSyC6aXtvQBxqEueZ3MYN9EmSp3Kqv1JY-EM'
    header = {:Authorization => authorization, :content_type => 'application/json'}
    distances.each_with_index do |distance, index|
      distances_empty = []
      distances_temp = distances_empty + distances
      distances_temp.delete_at(index)
      data = {:data =>
                {:gcm_initial_user => initilial_user,
                 :gcm_users => distances_temp,
                 :gcm_name_room => name_room},
                 :to => distance.instance_id
             }.to_json
      RestClient.post 'https://gcm-http.googleapis.com/gcm/send', data, header
    end
  end

  def ApplicationHelper.find_nearest_people(user_initial, people_limit)
    distances = []
    users = []
    User.all.each do |user|
      if user.available && !user.token.eql?(user_initial.token)
        users.push user
      end
    end
    # users = User.where("available = ?", true)
    users.each do |user|
      distance = ApplicationHelper.caculate_location(user_initial, user)
      # distances.push(Distance.new(distance, user.phone_number, user.name, user.description, user.address))
      if distance < 10
        distances.push(Distance.new(distance, user.phone_number, user.name, user.description, user.address, user.token, user.instance_id))
      end
    end
    distances.sort! { |a,b| a.getMile <=> b.getMile }
    return distances.take(people_limit)
  end

  def ApplicationHelper.find_nearest_people_voip(user_initial, people_limit)
    distances = []
    users = []
    UsersVoip.all.each do |user|
      if user.available && !user.token.eql?(user_initial.token)
        users.push user
      end
    end
    # users = User.where("available = ?", true)
    users.each do |user|
      distance = ApplicationHelper.caculate_location(user_initial, user)
      # distances.push(Distance.new(distance, user.phone_number, user.name, user.description, user.address))
      if distance < 10
        distances.push(Distance.new(distance, user.phone_number, user.name, user.description, user.address, user.token, user.instance_id))
      end
    end
    distances.sort! { |a,b| a.getMile <=> b.getMile }
    return distances.take(people_limit)
  end

  def ApplicationHelper.say_message(is_from_caller, participants, name_of_caller)
    participants_temp = participants.to_i
    if is_from_caller.eql?("true")
      if participants_temp.eql?(1)
        message = 'We have found 1 person ready to help you '
      elsif participants_temp >= 2
        message = "We have found #{ participants_temp } people ready to help you "
      else
        message = 'You have joined the conference.'
      end
    else
      message = "#{ name_of_caller } need your help, You have joined the conference."
    end
    return message
  end

  def ApplicationHelper.call_conference(name_room, participants, is_from_caller, name_of_caller)
    message = ApplicationHelper.say_message is_from_caller, participants, name_of_caller
    ApplicationHelper.log_conference_call name_room
    Twilio::TwiML::Response.new do |response|
      response.Say message
      response.Dial callerId: name_of_caller do |dial|
        dial.Conference name_room,
          waitUrl: "http://twimlets.com/holdmusic?Bucket=com.twilio.music.classical",
          muted:  "false",
          startConferenceOnEnter: "true",
          endConferenceOnExit: "true"
      end
    end
  end

  def ApplicationHelper.log_conference_call(name_room)
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token  = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new account_sid, auth_token
    if Log.exists?(:name_room => name_room)
      log = Log.find_by(name_room: name_room)
      if log.id_conference.eql?(nil)
        cf_id = nil
        statuses = ["init", "in-progress", "completed"]
        statuses.each do |status|
          @client.account.conferences.list({
            :status => status,
            :friendly_name => name_room}).each do |conference|
              cf_id = conference.sid
              Rails.logger.info "init"
            end
        end
        if !cf_id.eql?(nil)
          log_temp = {:id_conference => cf_id}
          log.update log_temp
        end
      end
    end
  end

  def ApplicationHelper.log_conference_call_voip(name_room)
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token  = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new account_sid, auth_token
    if LogVoip.exists?(:name_room => name_room)
      log = LogVoip.find_by(name_room: name_room)
      if log.id_conference.eql?(nil)
        cf_id = nil
        statuses = ["init", "in-progress", "completed"]
        statuses.each do |status|
          @client.account.conferences.list({
            :status => status,
            :friendly_name => name_room}).each do |conference|
              cf_id = conference.sid
              Rails.logger.info "init"
            end
        end
        if !cf_id.eql?(nil)
          log_temp = {:id_conference => cf_id}
          log.update log_temp
        end
      end
    end
  end

  def ApplicationHelper.save_rating(voter_token, arr_voted_tokens, name_room)
    if User.exists?(:token => voter_token)
      user = User.find_by(token: voter_token)
      log = Log.find_by(name_room: name_room)
      arr_voted_tokens.each do |arr|
        user_voted = User.find_by(token: arr[:token])
        if !user_voted.eql?(nil)
          user_voted.rates.create(
            rate_status: arr[:rateStatus],
            voter_id: user.id,
            voter_name: user.name,
            user_name: user_voted.name,
            room_name: name_room,
            log_id: log.id
            )
        end
      end
      result = true
    else
      result = false
    end
    return result
  end

  def ApplicationHelper.save_rating_voip(voter_token, arr_voted_tokens, name_room)
    if UsersVoip.exists?(:token => voter_token)
      user = UsersVoip.find_by(token: voter_token)
      log = LogVoip.find_by(name_room: name_room)
      arr_voted_tokens.each do |arr|
        user_voted = UsersVoip.find_by(token: arr[:token])
        # if !user_voted.eql?(nil)
        #   user_voted.rate_voips.create(
        #     rate_status: arr[:rateStatus],
        #     voter_id: user.id,
        #     voter_name: user.name,
        #     user_name: user_voted.name,
        #     room_name: name_room,
        #     log_id: log.id
        #     )
        # end
      end
      result = true
    else
      result = false
    end
    return result
  end

  def ApplicationHelper.random_activate_code
    prng = Random.new
    prng.rand(100000..999999)
  end

  def ApplicationHelper.generate_token
      token = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless User.exists?(:token => random_token)
      end
      return token
  end

  def ApplicationHelper.caculate_location(user_first, user_second)
    Geocoder::Calculations.distance_between([user_first.latitude, user_first.longitude], [user_second.latitude, user_second.longitude])
  end

end
