class RemovePasswordFromAuthentication < ActiveRecord::Migration
  def change
    remove_column :authentications, :password, :string
  end
end
