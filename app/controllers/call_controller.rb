class CallController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def connect
    render xml: twilio_reponse.to_xml
  end

  def showConferenceStatus
    render json: { status: showStatus }
  end

  private

  def twilio
    Twilio::TwiML::Response.new do |response|
      response.Say "You have joined the conference."
      response.Dial callerId: params[:Caller] do |dial|
          dial.Conference "conference",
            waitUrl: "http://twimlets.com/holdmusic?Bucket=com.twilio.music.classical",
            muted:  "false",
            startConferenceOnEnter: "true",
            endConferenceOnExit: "true"
      end
    end
  end

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
          Rails.logger.info conference

          endConfenrence = "false"
          if params.include?(:People)
            people = params[:People]
            Rails.logger.info people
            ary = people.chomp.split(' ')
            Rails.logger.info ary
            account_sid = ENV['TWILIO_ACCOUNT_SID']
            auth_token  = ENV['TWILIO_AUTH_TOKEN']
            callclient(account_sid, auth_token, ary)
            Rails.logger.info account_sid
            endConfenrence = "true"
          end

          dial.Conference conference,
            waitUrl: "http://twimlets.com/holdmusic?Bucket=com.twilio.music.classical",
            muted:  "false",
            startConferenceOnEnter: "true",
            endConferenceOnExit: endConfenrence
        else  #  conference
          Rails.logger.info "Call Client"
          dial.Client(params[:To])
        end
      end
    end
  end

  def callclient(account_sid, auth_token, ary)
    # ary.each { |a| Rails.logger.info a }
    @client = Twilio::REST::Client.new account_sid, auth_token
    ary.each { |a| Rails.logger.info a }
    temp = 0

    while temp < ary.size do
      call = @client.account.calls.create(:url => "http://demo.twilio.com/docs/voice.xml",
        :to => "client:" + ary.at(temp),
        :from => "+14158675309")
      puts call.start_time
      temp += 1
    end
  end

  def showStatus
    ary = Array.new
    if params.include?(:People)
      people = params[:People]
      ary = people.chomp.split(' ')
      Rails.logger.info ary
    end
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token  = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new account_sid, auth_token
    status = false
    @id_conference = ' '
    @client.account.conferences.list({
      :status => "in-progress",
      :friendlyName => "Myroom"}).each do |conference|
      # status = true
      puts conference.sid
      @id_conference = conference.sid
    end

    count_participant = @client.account.conferences.get(@id_conference).participants.list.size
    puts count_participant

    if count_participant  >= 2
      return true
    else
      return false
    end
  end

end
