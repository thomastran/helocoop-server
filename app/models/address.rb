class Address

  def initialize(latitude, longitude, token, instance_id, phone_number)
    @latitude = latitude
    @longitude = longitude
    @token = token
    @instance_id = instance_id
    @phone_number = phone_number
  end

  def getLatitude
    @latitude
  end

  def getLongitude
    @longitude
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
