class Distance
  attr_accessor :mile, :phone_number, :name, :description, :address
  def initialize(mile, phone_number, name, description, address)
    @mile = mile
    @phone_number = phone_number
    @name = name
    @description = description
    @address = address
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
