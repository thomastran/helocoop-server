class RemovePointFromRate < ActiveRecord::Migration
  def change
    remove_column :rates, :point, :float
  end
end
