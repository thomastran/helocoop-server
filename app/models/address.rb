class Address

  def initialize(latitude, longitude, token, instance_id)
    @latitude = latitude
    @longitude = longitude
    @token = token
    @instance_id = instance_id
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
end
