class AddLogIdToRate < ActiveRecord::Migration
  def change
    add_column :rates, :log_id, :integer
  end
end
