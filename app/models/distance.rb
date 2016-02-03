class Distance
  attr_accessor :mile, :phone_number, :name, :description, :address, :token
  def initialize(mile, phone_number, name, description, address, token, instance_id)
    @mile = mile
    @phone_number = phone_number
    @name = name
    @description = description
    @address = address
    @token = token
    @instance_id = instance_id
  end

  def getMile
    @mile
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
