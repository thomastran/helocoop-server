class AddRateVoipIdToUsersVoip < ActiveRecord::Migration
  def change
    add_column :users_voips, :rate_voip_id, :integer
  end
end
