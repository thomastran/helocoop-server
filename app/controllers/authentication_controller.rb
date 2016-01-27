class AuthenticationController < ApplicationController
  # before_action :authenticate_authentication!
  skip_before_filter :verify_authenticity_token

  def create
    user = {:email => 'samnguyen@novahub.vn', :password => '123456789'}
    user_temp = Authentication.new user
    if user_temp.save
      message = 'success'
    else
      message = 'failed'
    end
    render json: {:message => message}
  end
end
