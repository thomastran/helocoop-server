class VoipController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def generate_token
    if params.include?(:from_token)
      if UsersVoip.exists?(:token => params[:from_token])
        token = ::TwilioCapability.generate(params[:from_token])
        success = true
        message = 'generate token successfully'
      else
        token = nil
        success = false
        message = 'token does not exists'
      end
    else
      token = nil
      success = false
      message = 'Please check paramaters'
    end
    result = {:success => success, :token => token, :message => message}
    render json: result, status: 200
  end

  def request_code
    activate_code = ApplicationHelper.random_activate_code.to_s
    if params.include?(:phone_number)
        # send_sms params[:phone_number], activate_code
      ApplicationHelper.send_sms params[:phone_number], activate_code
      if UsersVoip.exists?(:phone_number => params[:phone_number])
        user = UsersVoip.find_by(phone_number: params[:phone_number])
        user_temp = {:code => activate_code}
        user.update(user_temp)
        result = {:success => true, :message => 'updated new phone number successfully'}
      else
        user_temp = {:phone_number => params[:phone_number], :code => activate_code}
        user = UsersVoip.new(user_temp)
        if user.save
          result = {:success => true, :message => 'created new phone number successfully'}
        else
          result = {:success => false, :message => 'created new phone number unsuccessfully'}
        end
      end
    end
    render json: result, status: 200
  end


  def verify_code
    if params.include?(:phone_number) and params.include?(:activate_code)
      if UsersVoip.exists?(:phone_number => params[:phone_number], :code => params[:activate_code])
        success = true
        message = 'activate successfully'
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
      render json: ApplicationHelper.update_user_voip(phone_number, email, address, name, description)
    else
      result = {:success => false, :message => 'please check the paramaters'}
      render json: result
    end
  end

  def update_location
    if params.include?(:latitude) and params.include?(:longitude) and params.include?(:token)
      user_temp = {:latitude => params[:latitude], :longitude => params[:longitude], :available => true }
      user = UsersVoip.find_by(:token => params[:token])
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

  # Update location and turn on Samaritan status to true
  def update_location_service
    if params.include?(:latitude) and params.include?(:longitude) and params.include?(:token)
      user_temp = {:latitude => params[:latitude], :longitude => params[:longitude]}
      user = UsersVoip.find_by(:token => params[:token])
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

  def get_instance_id
    if params.include?(:instance_id) and params.include?(:token)
      if UsersVoip.exists?(:token => params[:token])
        user_temp = {:instance_id => params[:instance_id]}
        user = UsersVoip.find_by(:token => params[:token])
        if user.update(user_temp)
          success = true
          message = 'Update instance_id successfully'
        else
          success = false
          message = 'Cannot update instance_id to database'
        end
      else
        success = false
        message = 'Token does not exist'
      end
    else
      success = false
      message = 'please check paramaters'
    end
    result = {:success => success, :message => message}
    render json: result, status: 200
  end

  # turn off Samaritan
  def turn_off_samaritan
    if params.include?(:token)
      user_temp = {:available => false}
      if UsersVoip.exists?(:token => params[:token])
        user = UsersVoip.find_by(:token => params[:token])
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
  # turn on samaritan
  def turn_on_samaritan
    if params.include?(:token)
      user_update = {:available => true}
      if UsersVoip.exists?(:token => params[:token])
        user = UsersVoip.find_by(:token => params[:token])
        if user.update user_update
          success = true
          message = 'Update available successfully !'
        else
          success = false
          message = 'Cannot update data to the users table'
        end
      else
        success = false
        message = 'Token does not exist'
      end
    else
      success = false
      message = 'Please check paramaters'
    end
    result = {:success => success, :message => message}
    render json: result
  end

end
