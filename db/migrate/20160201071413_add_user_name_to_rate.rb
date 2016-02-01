class AddUserNameToRate < ActiveRecord::Migration
  def change
    add_column :rates, :user_name, :string
  end
end
