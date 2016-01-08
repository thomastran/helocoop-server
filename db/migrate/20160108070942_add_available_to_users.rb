class AddAvailableToUsers < ActiveRecord::Migration
  def change
    add_column :users, :available, :string
  end
end
