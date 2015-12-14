class TokenController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def generate
    from_contact = params[:from_contact]

    token = ::TwilioCapability.generate(from_contact)
    render json: { token: token }
  end

end
