ActiveAdmin.register User do
  before_action :authenticate_authentication!
  actions :all, except: [:destroy, :new, :edit]
  menu priority: 1, label: "Users Account" # so it's on the very left
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params :phone_number, :email, :code, :address, :name, :created_at, :updated_at, :token, :latitude, :longitude, :available, :instance_id, :description

  # sidebar "Twilio Conference Log", only: [:show] do
  #   ul do
  #     li link_to "Show Log", admin_user_logs_path(user)
  #   end
  # end
  #
  # action_item :view, only: :show do
  #   link_to 'View on site', admin_user_logs_path(user)
  # end

  index do
    selectable_column
    column :name 
    column :phone_number
    column :description
    column :email
    column :latitude
    column :longitude
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
    end
    para "Press cancel to return to the list without saving."
    actions
  end

  controller do
    # This code is evaluated within the controller class
    def go
      puts "sam"
      render json: {:go => true}
    end
  end

#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
