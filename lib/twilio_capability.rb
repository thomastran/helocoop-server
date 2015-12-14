class TwilioCapability


  def self.generate(from_contact)
    # To find TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN visit
    # https://www.twilio.com/user/account
    account_sid = "AC6825c3d1d47edc3cabf866d484a1f356"
    auth_token  = "cc4ef8ad2e7cddc3d27e7e9f29451e18"
    capability = Twilio::Util::Capability.new account_sid, auth_token

    application_sid = "AP5700a88d7191590fcf7df7432bc4f7a6"
    capability.allow_client_outgoing application_sid

    (all_clients - [from_contact]).each {|role| capability.allow_client_incoming role}
    # capability.allow_client_incoming role
    capability.generate
  end

  def self.all_clients
    %w(contact1 contact2 contact3 contact4 contact5 contact6 contact7)
  end

end
