class RemoveLogIdFromRate < ActiveRecord::Migration
  def change
    remove_column :rates, :log_id, :interger
  end
end
