ActiveAdmin.register Rate do
before_action :authenticate_authentication!
actions :all, except: [:destroy, :new, :edit]
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
  column :user_name do |rate|
    link_to rate.user_name, admin_user_path(rate.user_id)
  end
  column "Voted by", :voter_name do |rate|
    link_to rate.voter_name, admin_user_path(rate.voter_id)
  end
  column :room_name do |rate|
    link_to rate.room_name, admin_log_path(rate.log_id)
  end
  column :rate_status
  column :created_at
  actions
end
show do
  panel "Information Details" do
    table_for rate do
      column :user_name
      column :voter_name
      column :room_name
      column :rate_status
      column :created_at
    end
  end
  # active_admin_comments
end
action_item :view, only: :show do
  link_to 'View on site', post_path(rate)
end

end
