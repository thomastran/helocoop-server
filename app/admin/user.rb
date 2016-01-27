ActiveAdmin.register User do
  # before_action :authenticate_authentication!


# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params :phone_number, :email, :code, :address, :name, :created_at, :updated_at, :token, :latitude, :longitude, :available, :instance_id, :description
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
