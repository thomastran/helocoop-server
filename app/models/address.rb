class Address

  def initialize(latitude, longitude, token)
    @latitude = latitude
    @longitude = longitude
    @token = token
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
end
