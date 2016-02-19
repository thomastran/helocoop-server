class ChangeDataTypeForAvailable < ActiveRecord::Migration
  def change
    # change_column :users, :available,  'boolean USING CAST(available AS boolean)'
    change_column :users, :available,  :boolean
  end
end
