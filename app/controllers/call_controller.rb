class CallController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def connect
    render xml: twilio_reponse.to_xml
  end

  private

  def twilio_reponse
    Twilio::TwiML::Response.new do |response|
      response.Dial callerId: params[:Caller] do |dial|
        if params.include?(:phoneNumber)
          dial.Number params[:phoneNumber]
        else
          dial.Client(params[:To])
        end
      end
    end
  end
end



