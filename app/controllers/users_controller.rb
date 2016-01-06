class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def register
    activate_code = random_activate_code
    if params.include?(:phone_number)
      user_temp = { "phone_number" => params[:phone_number], "code" => activate_code }
      @user = User.new(user_temp)
      if @user.save
        result = { "success" => true, "message" => "created new phone number successfully" }
      else
        result = { "success" => false, "message" => "created new phone number unsuccessfully" }
      end
    end
    render json: result
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

  def activate_code
    if params.include?(:phone_number) and params.include?(:activate_code)
      user = User.find_by(phone_number: params[:phone_number], code: params[:activate_code])
      if user != nil
        Rails.logger.info user.phone_number
        Rails.logger.info user.code
        success = true
        message = "activate successfully"
      else
        success = false
        message = "phone number doesn't exist"
      end
    else
      success = false
      message = "please check the paramaters"
    end
    result = { "success" => success, "message" => message }
    render json: result
  end

  def show_all_user
    render json: User.all
  end

  def clear_data_user
    if User.delete_all
      success = true
    else
      success = false
    end
    result = { "success" => success }
    render json: result
  end

  private

  def do_register
    if params.include?(:phone_number)
      phoneNumber = params[:phone_number]
      Rails.logger.info phoneNumber
    end
  end

  def update_user(phone_number, email, address, name)
    user_temp = { "email" => email, "address" => address, "name" => name }
    user = User.find_by(phone_number: phone_number)

    if user.update(user_temp)
      success = true
      message = "updated successfully"
    else
      success = false
      message = "updated unsuccessfully"
    end

    result = { "success" => success, "message" => message }

    return result
  end


  def random_activate_code
    prng = Random.new
    prng.rand(1000..9999)
  end

end
