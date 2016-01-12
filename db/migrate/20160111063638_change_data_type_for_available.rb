class ChangeDataTypeForAvailable < ActiveRecord::Migration
  def change
    change_column :users, :available,  'boolean USING CAST(available AS boolean)'
  end
end
