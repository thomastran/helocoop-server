class AddUsersVoipIdToLogVoip < ActiveRecord::Migration
  def change
    add_column :log_voips, :users_voip_id, :integer
  end
end
