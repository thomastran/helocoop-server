class AddInstanceIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :instance_id, :string
  end
end
