class AddUsersVoipIdToRateVoip < ActiveRecord::Migration
  def change
    add_column :rate_voips, :users_voip_id, :integer
  end
end
