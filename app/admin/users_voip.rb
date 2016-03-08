ActiveAdmin.register UsersVoip do
  before_action :authenticate_authentication!
  actions :all, except: [:destroy, :new]
  menu priority: 4, label: "Users Voip" # so it's on the very left
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :phone_number, :email, :code, :address, :name, :created_at, :updated_at, :token, :latitude, :longitude, :available, :instance_id, :description
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
index do
  selectable_column
  column :name
  column :phone_number
  column :description
  column :email
  column :latitude
  column :longitude
  column :available
  column :address
  actions
end

show do
  panel "Information Details" do
    table_for user do
      column :name
      column :phone_number
      column :email
      column :description
      column :latitude
      column :longitude
      column :address
    end
  end
  # active_admin_comments
end

form title: 'Change Some Infomation ' do |f|
  inputs 'Details' do
    input :name, label: "Full name"
    input :phone_number, label: "Phone number"
    input :email, label: "Email"
    input :address, label: "Address"
    input :description, label: "Description"
    input :latitude
    input :longitude
  end
  para "Press cancel to return to the list without saving."
  actions
end


end
