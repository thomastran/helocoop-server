class Distance

  def initialize(mile, token, instance_id, phone_number, name, description, address)
    @mile = mile
    @token = token
    @instance_id = instance_id
    @phone_number = phone_number
    @name = name
    @description = description
    @address = address
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
