class CallController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def connect
    render xml: twilio_reponse.to_xml
  end

  private

  def twilio_reponse
    Twilio::TwiML::Response.new do |response|
      response.Say "You have joined the conference."

      response.Dial callerId: params[:Caller] do |dial|
        if params.include?(:phoneNumber)
          Rails.logger.info "Call phone number"
          dial.Number params[:phoneNumber]
        elsif params.include?(:Conference)
           Rails.logger.info "Call Conference"
          conference = params[:Conference] || "Conference01"
          dial.Conference conference,
            waitUrl: "http://twimlets.com/holdmusic?Bucket=com.twilio.music.classical",
            muted:  "false",
            startConferenceOnEnter: "true",
            endConferenceOnEnter: "true"
        else  #  conference
          Rails.logger.info "Call Client"
          dial.Client(params[:To])
        end
      end
    end
  end
end
