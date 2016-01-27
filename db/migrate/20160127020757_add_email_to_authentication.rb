class AddEmailToAuthentication < ActiveRecord::Migration
  def change
    add_column :authentications, :email, :string
    add_column :authentications, :password, :string
  end
end
