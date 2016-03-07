class AddUsersVoipIdToRateVoip < ActiveRecord::Migration
  def change
    add_column :rate_voips, :usersvoip_id, :integer
  end
end
