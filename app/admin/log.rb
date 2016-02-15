ActiveAdmin.register Log do
before_action :authenticate_authentication!
actions :all, except: [:destroy, :new, :edit]
menu priority: 2, label: "Twilio Conference Logs"
# belongs_to :user
# navigation_menu :user
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
  column :name_room
  column :participants
  column :caller do |log|
    link_to log.caller, admin_user_path(log.user_id)
  end
  column :created_at
  actions
end

show do
  panel "Information Details" do
    table_for log do
      column :id_conference
      column :name_room
      column :participants
      column :caller
      column :created_at
    end
  end
  # active_admin_comments
end


end
