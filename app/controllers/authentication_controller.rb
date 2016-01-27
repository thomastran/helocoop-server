class AuthenticationController < ApplicationController
  before_action :authenticate_authentication!
  skip_before_filter :verify_authenticity_token


  def create
    if user_signed_in?
      message = true
    else
      message = false
    end
    render json: {:message => message}
  end
end
