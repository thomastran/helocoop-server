module ApplicationHelper
  def ApplicationHelper.test()
    puts "just testing"
  end

  def ApplicationHelper.send_sms(phone_number, activate_code)
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token  = ENV['TWILIO_AUTH_TOKEN']
    message = 'Your HelpCoop activation number is '+ activate_code +'. Please enter this number in the HelpCoop app to activate.'
    @client = Twilio::REST::Client.new account_sid, auth_token
    @client.account.messages.create({
      :from => '+14157809231',
      :to => phone_number,
      :body => message
    })
  end
end
