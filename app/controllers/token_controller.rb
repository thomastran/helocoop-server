class TokenController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def generate
    from_contact = params[:from_contact]
    if params.include?(:latitude) and params.include?(:longitude)
      user_temp = { "latitude" => params[:latitude], "longitude" => params[:longitude], "available" => true }
      user = User.find_by(token: params[:from_contact])
      user.update(user_temp)
    end
    token = ::TwilioCapability.generate(from_contact)
    render json: { token: token }
  end

end
