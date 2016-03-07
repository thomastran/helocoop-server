class AddUsersVoipIdToLogVoip < ActiveRecord::Migration
  def change
    add_column :log_voips, :usersvoip_id, :integer
  end
end
