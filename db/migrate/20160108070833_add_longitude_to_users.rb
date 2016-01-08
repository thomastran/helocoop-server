class AddLongitudeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :longitude, :string
  end
end
