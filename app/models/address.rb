class Address

  def initialize(latitude, longitude, token, instance_id, phone_number, name, description, address)
    @latitude = latitude
    @longitude = longitude
    @token = token
    @instance_id = instance_id
    @phone_number = phone_number
    @name = name
    @description = description
    @address = address
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

  def getDescription
    @description
  end

  def getAddress
    @address
  end

  def getName
    @name
  end
end
