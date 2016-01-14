class PhoneconferenceController < ApplicationController

  def index

  end

  def create
    phones = phones_params
    phones.each do |key, array|
      puts array
    end
    callclient phones
    redirect_to action: "index"
  end

  def callclient(phones)
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token  = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new account_sid, auth_token
    url = 'https://sleepy-tundra-5643.herokuapp.com/users/callconference'
    phone_number = '+14157809231'
    phones.each do |key, array|
      @client.account.calls.create(
      :url => url,
      :to => array,
      :from => phone_number
      )
    end
  end

  def phones_params
    params.require(:phones).permit(:first_number, :second_number, :third_number)
  end
end
