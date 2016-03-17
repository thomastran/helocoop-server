class DistanceVoip
  attr_accessor :mile, :phone_number, :name, :description, :address, :token, :instance_id, :latitude, :longitude
  def initialize(mile, phone_number, name, description, address, token, instance_id, latitude, longitude)
    @mile = mile
    @phone_number = phone_number
    @name = name
    @description = description
    @address = address
    @token = token
    @instance_id = instance_id
    @latitude = latitude
    @longitude = longitude
  end

end
