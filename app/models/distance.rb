class Distance

  def initialize(mile, token, instance_id, phone_number)
    @mile = mile
    @token = token
    @instance_id = instance_id
    @phone_number = phone_number
  end

  def getMile
    @mile
  end

  def getToken
    @token
  end

  def getInstanceId
    @instance_id
  end

  def getPhoneNumber
    @phone_number
  end

end
